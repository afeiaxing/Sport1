/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  UINavigationBar+Transition.m
//  qmui
//
//  Created by QMUI Team on 11/25/16.
//

#import "UINavigationBar+Transition.h"
#import "QMUICore.h"
#import "UINavigationBar+QMUI.h"
#import "UINavigationBar+QMUIBarProtocol.h"
#import "QMUIWeakObjectContainer.h"
#import "UIImage+QMUI.h"

@implementation UINavigationBar (Transition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
#ifdef IOS15_SDK_ALLOWED
        if (@available(iOS 15.0, *)) {
            ExtendImplementationOfVoidMethodWithSingleArgument([UINavigationBar class], @selector(setStandardAppearance:), UINavigationBarAppearance *, ^(UINavigationBar *selfObject, UINavigationBarAppearance *appearance) {
                if (selfObject.qmuinb_copyStylesToBar) {
                    selfObject.qmuinb_copyStylesToBar.standardAppearance = appearance;
                }
            });
            
            ExtendImplementationOfVoidMethodWithSingleArgument([UINavigationBar class], @selector(setScrollEdgeAppearance:), UINavigationBarAppearance *, ^(UINavigationBar *selfObject, UINavigationBarAppearance *appearance) {
                if (selfObject.qmuinb_copyStylesToBar) {
                    selfObject.qmuinb_copyStylesToBar.scrollEdgeAppearance = appearance;
                }
            });
        }
#endif
        
        ExtendImplementationOfVoidMethodWithSingleArgument([UINavigationBar class], @selector(setBarStyle:), UIBarStyle, ^(UINavigationBar *selfObject, UIBarStyle barStyle) {
            if (selfObject.qmuinb_copyStylesToBar && selfObject.qmuinb_copyStylesToBar.barStyle != barStyle) {
                selfObject.qmuinb_copyStylesToBar.barStyle = barStyle;
            }
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([UINavigationBar class], @selector(setBarTintColor:), UIColor *, ^(UINavigationBar *selfObject, UIColor *barTintColor) {
            if (selfObject.qmuinb_copyStylesToBar && ![selfObject.qmuinb_copyStylesToBar.barTintColor isEqual:barTintColor]) {
                selfObject.qmuinb_copyStylesToBar.barTintColor = barTintColor;
            }
        });
        
        OverrideImplementation([UINavigationBar class], @selector(setBackgroundImage:forBarMetrics:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, UIImage *image, UIBarMetrics barMetrics) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIImage *, UIBarMetrics);
                originSelectorIMP = (void (*)(id, SEL, UIImage *, UIBarMetrics))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, image, barMetrics);
                
                if (selfObject.qmuinb_copyStylesToBar) {
                    [selfObject.qmuinb_copyStylesToBar setBackgroundImage:image forBarMetrics:barMetrics];
                }
            };
        });
        
        ExtendImplementationOfVoidMethodWithSingleArgument([UINavigationBar class], @selector(setShadowImage:), UIImage *, ^(UINavigationBar *selfObject, UIImage *firstArgv) {
            if (selfObject.qmuinb_copyStylesToBar) {
                selfObject.qmuinb_copyStylesToBar.shadowImage = firstArgv;
            }
        });
        
        OverrideImplementation([UINavigationBar class], @selector(setQmui_effect:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, UIBlurEffect *firstArgv) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIBlurEffect *);
                originSelectorIMP = (void (*)(id, SEL, UIBlurEffect *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
                
                if (selfObject.qmuinb_copyStylesToBar) {
                    selfObject.qmuinb_copyStylesToBar.qmui_effect = firstArgv;
                }
            };
        });
        
        OverrideImplementation([UINavigationBar class], @selector(setQmui_effectForegroundColor:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UINavigationBar *selfObject, UIColor *firstArgv) {
                
                // call super
                void (*originSelectorIMP)(id, SEL, UIColor *);
                originSelectorIMP = (void (*)(id, SEL, UIColor *))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, firstArgv);
                
                if (selfObject.qmuinb_copyStylesToBar) {
                    selfObject.qmuinb_copyStylesToBar.qmui_effectForegroundColor = firstArgv;
                }
            };
        });
    });
}

static char kAssociatedObjectKey_copyStylesToBar;
- (void)setQmuinb_copyStylesToBar:(UINavigationBar *)copyStylesToBar {
    QMUIWeakObjectContainer *weakContainer = objc_getAssociatedObject(self, &kAssociatedObjectKey_copyStylesToBar);
    if (!weakContainer) {
        weakContainer = [[QMUIWeakObjectContainer alloc] init];
    }
    weakContainer.object = copyStylesToBar;
    objc_setAssociatedObject(self, &kAssociatedObjectKey_copyStylesToBar, weakContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!copyStylesToBar) return;
    
#ifdef IOS15_SDK_ALLOWED
    if (@available(iOS 15.0, *)) {
        copyStylesToBar.standardAppearance = self.standardAppearance;
        copyStylesToBar.scrollEdgeAppearance = self.scrollEdgeAppearance;
    } else {
#endif
        UIImage *backgroundImage = [self backgroundImageForBarMetrics:UIBarMetricsDefault];
        if (backgroundImage && backgroundImage.size.width <= 0 && backgroundImage.size.height <= 0) {
            // ??????????????????????????????`[UIImage new]`?????????????????????????????????navBar?????????????????????????????????navBar?????????????????????????????? navController ??????????????? navBar ??? [UIImage new] ???????????????????????????????????????
            backgroundImage = [UIImage qmui_imageWithColor:UIColorClear];
        }
        [copyStylesToBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        copyStylesToBar.shadowImage = self.shadowImage;
        
        if (copyStylesToBar.barStyle != self.barStyle) {
            copyStylesToBar.barStyle = self.barStyle;
        }
        
        // setTranslucent ?????? setBackgroundImage ??????????????? setBackgroundImage ??????????????? translucent ??????
        if (copyStylesToBar.translucent != self.translucent) {
            copyStylesToBar.translucent = self.translucent;
        }
        
        if (![copyStylesToBar.barTintColor isEqual:self.barTintColor]) {
            copyStylesToBar.barTintColor = self.barTintColor;
        }
        
#ifdef IOS15_SDK_ALLOWED
    }
#endif
    
    copyStylesToBar.qmui_effect = self.qmui_effect;
    copyStylesToBar.qmui_effectForegroundColor = self.qmui_effectForegroundColor;
}

- (UINavigationBar *)qmuinb_copyStylesToBar {
    return (UINavigationBar *)((QMUIWeakObjectContainer *)objc_getAssociatedObject(self, &kAssociatedObjectKey_copyStylesToBar)).object;
}

@end

@implementation _QMUITransitionNavigationBar

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // iOS 14 ?????? customNavigationBarTransitionKey ??????????????????????????????
        // https://github.com/Tencent/QMUI_iOS/issues/1081
        if (@available(iOS 14.0, *)) {
            // - [UINavigationBar _accessibility_navigationController]
            OverrideImplementation([_QMUITransitionNavigationBar class], NSSelectorFromString([NSString stringWithFormat:@"_%@_%@", @"accessibility", @"navigationController"]), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^UINavigationController *(_QMUITransitionNavigationBar *selfObject) {
                    if (selfObject.originalNavigationBar) {
                        BeginIgnorePerformSelectorLeaksWarning
                        return [selfObject.originalNavigationBar performSelector:originCMD];
                        EndIgnorePerformSelectorLeaksWarning
                    }
                    
                    // call super
                    UINavigationController *(*originSelectorIMP)(id, SEL);
                    originSelectorIMP = (UINavigationController *(*)(id, SEL))originalIMPProvider();
                    UINavigationController *result = originSelectorIMP(selfObject, originCMD);
                    return result;
                };
            });
        }
        
#ifdef IOS15_SDK_ALLOWED
        if (@available(iOS 15.0, *)) {
            // - [UINavigationBar _didMoveFromWindow:toWindow:]
            OverrideImplementation([_QMUITransitionNavigationBar class], NSSelectorFromString(@"_didMoveFromWindow:toWindow:"), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
                return ^(_QMUITransitionNavigationBar *selfObject, UIWindow *firstArgv, UIWindow *secondArgv) {
                    
                    if (selfObject.shouldPreventAppearance) {
                        return;
                    }
                    
                    // call super
                    void (*originSelectorIMP)(id, SEL, UIWindow *, UIWindow *);
                    originSelectorIMP = (void (*)(id, SEL, UIWindow *, UIWindow *))originalIMPProvider();
                    originSelectorIMP(selfObject, originCMD, firstArgv, secondArgv);
                };
            });
        }
#endif

    });
}

- (void)setOriginalNavigationBar:(UINavigationBar *)originBar {
    _originalNavigationBar = originBar;
    
    // ??????????????? originBar ??????????????????????????????????????????
    originBar.qmuinb_copyStylesToBar = self;
    originBar.qmuinb_copyStylesToBar = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // ?????? iOS 11 Beta 1-5 ???????????? init ??? navigationBar.backgroundView.height ??????????????? 44??????????????????????????????
    self.qmui_backgroundView.frame = self.bounds;
}

// NavBarRemoveBackgroundEffectAutomatically ???????????? AutomaticCustomNavigationBarTransitionStyle ??????????????? bar ??????
// https://github.com/Tencent/QMUI_iOS/issues/1330
- (void)didAddSubview:(UIView *)subview {
    [super didAddSubview:subview];
    if (subview == self.qmui_backgroundView) {
        [subview qmui_performSelector:NSSelectorFromString(@"updateBackground") withArguments:nil];
    }
}

@end
