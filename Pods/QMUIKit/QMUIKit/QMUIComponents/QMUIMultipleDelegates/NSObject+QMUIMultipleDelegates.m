/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  NSObject+MultipleDelegates.m
//  QMUIKit
//
//  Created by QMUI Team on 2018/3/27.
//

#import "NSObject+QMUIMultipleDelegates.h"
#import "QMUIMultipleDelegates.h"
#import "QMUICore.h"
#import "NSPointerArray+QMUI.h"
#import "NSString+QMUI.h"

@interface NSObject ()

@property(nonatomic, strong) NSMutableDictionary<NSString *, QMUIMultipleDelegates *> *qmuimd_delegates;
@end

@implementation NSObject (QMUIMultipleDelegates)

QMUISynthesizeIdStrongProperty(qmuimd_delegates, setQmuimd_delegates)

static char kAssociatedObjectKey_qmuiMultipleDelegatesEnabled;
- (void)setQmui_multipleDelegatesEnabled:(BOOL)qmui_multipleDelegatesEnabled {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_qmuiMultipleDelegatesEnabled, @(qmui_multipleDelegatesEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (qmui_multipleDelegatesEnabled) {
        if (!self.qmuimd_delegates) {
            self.qmuimd_delegates = [NSMutableDictionary dictionary];
        }
        [self qmui_registerDelegateSelector:@selector(delegate)];
        if ([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) {
            [self qmui_registerDelegateSelector:@selector(dataSource)];
        }
    }
}

- (BOOL)qmui_multipleDelegatesEnabled {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_qmuiMultipleDelegatesEnabled)) boolValue];
}

- (void)qmui_registerDelegateSelector:(SEL)getter {
    if (!self.qmui_multipleDelegatesEnabled) {
        return;
    }
    
    Class targetClass = [self class];
    SEL originDelegateSetter = setterWithGetter(getter);
    SEL newDelegateSetter = [self newSetterWithGetter:getter];
    Method originMethod = class_getInstanceMethod(targetClass, originDelegateSetter);
    if (!originMethod) {
        return;
    }
    
    NSString *delegateGetterKey = NSStringFromSelector(getter);
    
    [QMUIHelper executeBlock:^{
        IMP originIMP = method_getImplementation(originMethod);
        void (*originSelectorIMP)(id, SEL, id);
        originSelectorIMP = (void (*)(id, SEL, id))originIMP;
        
        BOOL isAddedMethod = class_addMethod(targetClass, newDelegateSetter, imp_implementationWithBlock(^(NSObject *selfObject, id aDelegate){
            
            // ????????????????????????????????? https://github.com/Tencent/QMUI_iOS/issues/292
            if (!selfObject.qmui_multipleDelegatesEnabled || selfObject.class != targetClass) {
                originSelectorIMP(selfObject, originDelegateSetter, aDelegate);
                return;
            }
            
            // ????????? selector ???????????? QMUIMultipleDelegates ??????
            QMUIMultipleDelegates *delegates = selfObject.qmuimd_delegates[delegateGetterKey];
            if (!aDelegate) {
                // ?????? setDelegate:nil???????????????????????? delegate
                if (delegates) {
                    [delegates removeAllDelegates];
                    [selfObject.qmuimd_delegates removeObjectForKey:delegateGetterKey];
                }
                // ????????????????????????????????? tableView:cellForRowAtIndexPath: ????????????????????????????????? nil??? ?????????????????? assert
                // https://github.com/Tencent/QMUI_iOS/issues/1411
                 originSelectorIMP(selfObject, originDelegateSetter, nil);
                return;
            }
            
            if (!delegates) {
                objc_property_t prop = class_getProperty(selfObject.class, delegateGetterKey.UTF8String);
                QMUIPropertyDescriptor *property = [QMUIPropertyDescriptor descriptorWithProperty:prop];
                if (property.isStrong) {
                    // strong property
                    delegates = [QMUIMultipleDelegates strongDelegates];
                } else {
                    // weak property
                    delegates = [QMUIMultipleDelegates weakDelegates];
                }
                delegates.parentObject = selfObject;
                selfObject.qmuimd_delegates[delegateGetterKey] = delegates;
            }
            
            if (aDelegate != delegates) {// ????????????????????????????????? delegates ????????? delegates ?????????????????????
                [delegates addDelegate:aDelegate];
            }
            
            originSelectorIMP(selfObject, originDelegateSetter, nil);// ????????? nil ????????? delegates??????????????????????????? https://github.com/Tencent/QMUI_iOS/issues/305
            originSelectorIMP(selfObject, originDelegateSetter, delegates);// ????????????????????? object ?????? setDelegate:???????????????????????????????????? QMUIMultipleDelegates ??????
            
        }), method_getTypeEncoding(originMethod));
        if (isAddedMethod) {
            Method newMethod = class_getInstanceMethod(targetClass, newDelegateSetter);
            method_exchangeImplementations(originMethod, newMethod);
        }
    } oncePerIdentifier:[NSString stringWithFormat:@"MultipleDelegates %@-%@", NSStringFromClass(targetClass), NSStringFromSelector(getter)]];
    
    // ????????????????????? delegate????????????????????????????????????
    // @see https://github.com/Tencent/QMUI_iOS/issues/378
    BeginIgnorePerformSelectorLeaksWarning
    id originDelegate = [self performSelector:getter];
    if (originDelegate && originDelegate != self.qmuimd_delegates[delegateGetterKey]) {
        [self performSelector:originDelegateSetter withObject:originDelegate];
    }
    EndIgnorePerformSelectorLeaksWarning
}

- (void)qmui_removeDelegate:(id)delegate {
    if (!self.qmuimd_delegates) {
        return;
    }
    NSMutableArray<NSString *> *delegateGetters = [[NSMutableArray alloc] init];
    [self.qmuimd_delegates enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, QMUIMultipleDelegates * _Nonnull obj, BOOL * _Nonnull stop) {
        BOOL removeSucceed = [obj removeDelegate:delegate];
        if (removeSucceed) {
            [delegateGetters addObject:key];
        }
    }];
    if (delegateGetters.count > 0) {
        for (NSString *getterString in delegateGetters) {
            [self refreshDelegateWithGetter:NSSelectorFromString(getterString)];
        }
    }
}

- (void)refreshDelegateWithGetter:(SEL)getter {
    SEL originSetterSEL = [self newSetterWithGetter:getter];
    BeginIgnorePerformSelectorLeaksWarning
    id originDelegate = [self performSelector:getter];
    [self performSelector:originSetterSEL withObject:nil];// ????????? nil ????????? delegates??????????????????????????? https://github.com/Tencent/QMUI_iOS/issues/305
    [self performSelector:originSetterSEL withObject:originDelegate];
    EndIgnorePerformSelectorLeaksWarning
}

// ?????? delegate property ??? getter????????? QMUIMultipleDelegates ????????? setter ???????????? setter ?????????????????????????????????????????????????????????????????? SEL??????????????????????????? delegate property setter ?????????
- (SEL)newSetterWithGetter:(SEL)getter {
    return NSSelectorFromString([NSString stringWithFormat:@"qmuimd_%@", NSStringFromSelector(setterWithGetter(getter))]);
}

@end
