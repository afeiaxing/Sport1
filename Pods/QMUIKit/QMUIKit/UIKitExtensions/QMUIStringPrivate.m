/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */
//
//  QMUIStringPrivate.m
//  QMUIKit
//
//  Created by molice on 2021/11/5.
//

#import "QMUIStringPrivate.h"
#import <CommonCrypto/CommonDigest.h>
#import "QMUICore.h"
#import "NSString+QMUI.h"

@implementation QMUIStringPrivate

+ (NSUInteger)transformIndexToDefaultMode:(NSUInteger)index inString:(NSString *)string {
    CGFloat strlength = 0.f;
    NSUInteger i = 0;
    for (i = 0; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if (strlength >= index + 1) return i;
    }
    return 0;
}

+ (NSRange)transformRangeToDefaultMode:(NSRange)range lessValue:(BOOL)lessValue inString:(NSString *)string {
    CGFloat strlength = 0.f;
    NSRange resultRange = NSMakeRange(NSNotFound, 0);
    NSUInteger i = 0;
    for (i = 0; i < string.length; i++) {
        unichar character = [string characterAtIndex:i];
        if (isascii(character)) {
            strlength += 1;
        } else {
            strlength += 2;
        }
        if ((lessValue && isascii(character) && strlength >= range.location + 1)
            || (lessValue && !isascii(character) && strlength > range.location + 1)
            || (!lessValue && strlength >= range.location + 1)) {
            if (resultRange.location == NSNotFound) {
                resultRange.location = i;
            }
            
            if (range.length > 0 && strlength >= NSMaxRange(range)) {
                resultRange.length = i - resultRange.location;
                if (lessValue && (strlength == NSMaxRange(range))) {
                    resultRange.length += 1;// ??????????????????????????????????????????????????????+1???????????????????????????????????????
                } else if (!lessValue) {
                    resultRange.length += 1;// ???????????????????????????????????????????????????+1
                }
                return resultRange;
            }
        }
    }
    return resultRange;
}

+ (NSRange)downRoundRangeOfComposedCharacterSequences:(NSRange)range inString:(NSString *)string {
    if (range.length == 0) {
        return range;
    }
    NSRange systemRange = [string rangeOfComposedCharacterSequencesForRange:range];// ????????????????????????
    if (NSEqualRanges(range, systemRange)) {
        return range;
    }
    NSRange result = systemRange;
    if (range.location > systemRange.location) {
        // ????????????????????? range ????????????????????? Character Sequence ??????????????????????????? Character Sequence ??????????????????????????????????????????
        NSRange beginRange = [string rangeOfComposedCharacterSequenceAtIndex:range.location];
        result.location = NSMaxRange(beginRange);
        result.length -= beginRange.length;
    }
    if (NSMaxRange(range) < NSMaxRange(systemRange)) {
        // ????????????????????? range ????????????????????? Character Sequence ??????????????????????????? Character Sequence ???????????????????????????????????????
        NSRange endRange = [string rangeOfComposedCharacterSequenceAtIndex:NSMaxRange(range) - 1];
        
        // ???????????????????????? range ?????????????????? emoji ???????????????????????????????????? beginRange ????????????????????? endRange?????????????????????????????? length ??? NSUInteger???????????????????????????????????? ????????????????????????? ??????????????? emoji ????????? 11
        if (result.length >= endRange.length) {
            result.length = result.length - endRange.length;
        } else {
            result.length = 0;
        }
    }
    return result;
}

+ (id)substring:(id)aString avoidBreakingUpCharacterSequencesFromIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    NSAttributedString *attributedString = [aString isKindOfClass:NSAttributedString.class] ? (NSAttributedString *)aString : nil;
    NSString *string = attributedString.string ?: (NSString *)aString;
    NSUInteger length = countingNonASCIICharacterAsTwo ? string.qmui_lengthWhenCountingNonASCIICharacterAsTwo : string.length;
    QMUIAssert(index <= length, @"QMUIStringPrivate", @"%s, index %@ out of bounds. string = %@", __func__, @(index), attributedString ?: string);
    if (index >= length) return @"";
    index = countingNonASCIICharacterAsTwo ? [self transformIndexToDefaultMode:index inString:string] : index;// ???????????????????????????????????? length ?????????
    NSRange range = [string rangeOfComposedCharacterSequenceAtIndex:index];
    index = range.length == 1 ? index : (lessValue ? NSMaxRange(range) : range.location);
    if (attributedString) {
        NSAttributedString *resultString = [attributedString attributedSubstringFromRange:NSMakeRange(index, string.length - index)];
        return resultString;
    }
    NSString *resultString = [string substringFromIndex:index];
    return resultString;
}

+ (id)substring:(id)aString avoidBreakingUpCharacterSequencesToIndex:(NSUInteger)index lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    NSAttributedString *attributedString = [aString isKindOfClass:NSAttributedString.class] ? (NSAttributedString *)aString : nil;
    NSString *string = attributedString.string ?: (NSString *)aString;
    NSUInteger length = countingNonASCIICharacterAsTwo ? string.qmui_lengthWhenCountingNonASCIICharacterAsTwo : string.length;
    QMUIAssert(index <= length, @"QMUIStringPrivate", @"%s, index %@ out of bounds. string = %@", __func__, @(index), attributedString ?: string);
    if (index == 0 || index > length) return @"";
    if (index == length) return [aString copy];// ???????????? -[NSString substringToIndex:] ??????????????? index ?????? length ???????????? self ??? copy???
    index = countingNonASCIICharacterAsTwo ? [self transformIndexToDefaultMode:index inString:string] : index;// ???????????????????????????????????? length ?????????
    NSRange range = [string rangeOfComposedCharacterSequenceAtIndex:index];
    index = range.length == 1 ? index : (lessValue ? range.location : NSMaxRange(range));
    if (attributedString) {
        NSAttributedString *resultString = [attributedString attributedSubstringFromRange:NSMakeRange(0, index)];
        return resultString;
    }
    NSString *resultString = [string substringToIndex:index];
    return resultString;
}

+ (id)substring:(id)aString avoidBreakingUpCharacterSequencesWithRange:(NSRange)range lessValue:(BOOL)lessValue countingNonASCIICharacterAsTwo:(BOOL)countingNonASCIICharacterAsTwo {
    NSAttributedString *attributedString = [aString isKindOfClass:NSAttributedString.class] ? (NSAttributedString *)aString : nil;
    NSString *string = attributedString.string ?: (NSString *)aString;
    NSUInteger length = countingNonASCIICharacterAsTwo ? string.qmui_lengthWhenCountingNonASCIICharacterAsTwo : string.length;
    QMUIAssert(NSMaxRange(range) <= length, @"QMUIStringPrivate", @"%s, range %@ out of bounds. string = %@", __func__, NSStringFromRange(range), attributedString ?: string);
    if (NSMaxRange(range) > length) return @"";
    range = countingNonASCIICharacterAsTwo ? [self transformRangeToDefaultMode:range lessValue:lessValue inString:string] : range;// ???????????????????????????????????? length ?????????
    NSRange characterSequencesRange = lessValue ? [self downRoundRangeOfComposedCharacterSequences:range inString:string] : [string rangeOfComposedCharacterSequencesForRange:range];
    if (attributedString) {
        NSAttributedString *resultString = [attributedString attributedSubstringFromRange:characterSequencesRange];
        return resultString;
    }
    NSString *resultString = [string substringWithRange:characterSequencesRange];
    return resultString;
}

+ (id)string:(id)aString avoidBreakingUpCharacterSequencesByRemoveCharacterAtIndex:(NSUInteger)index {
    NSAttributedString *attributedString = [aString isKindOfClass:NSAttributedString.class] ? (NSAttributedString *)aString : nil;
    NSString *string = attributedString.string ?: (NSString *)aString;
    NSRange rangeForRemove = [string rangeOfComposedCharacterSequenceAtIndex:index];
    if (attributedString) {
        NSMutableAttributedString *resultString = attributedString.mutableCopy;
        [resultString replaceCharactersInRange:rangeForRemove withString:@""];
        return resultString.copy;
    }
    NSString *resultString = [string stringByReplacingCharactersInRange:rangeForRemove withString:@""];
    return resultString;
}

@end

@implementation QMUIStringPrivate (Safety)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self qmuisafety_NSString];
        [self qmuisafety_NSAttributedString];
    });
}

+ (void)qmuisafety_NSString {
    OverrideImplementation([NSString class], @selector(substringFromIndex:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^NSString *(NSString *selfObject, NSUInteger index) {
            
            // index ??????
            {
                BOOL isValidatedIndex = index <= selfObject.length;
                if (!isValidatedIndex) {
                    NSString *logString = [NSString stringWithFormat:@"%@ ??????????????????????????????????????? index: %@??????????????????: %@(%@)", NSStringFromSelector(originCMD), @(index), selfObject, @(selfObject.length)];
                    QMUIAssert(NO, @"QMUIStringSafety", @"%@", logString);
                    return @"";// ?????? substringFromIndex: ????????????????????? nonnull
                }
            }
            
            // ????????? emoji ??? ComposedCharacterSequence ?????????????????????
            {
                if (index < selfObject.length) {
                    NSRange range = [selfObject rangeOfComposedCharacterSequenceAtIndex:index];
                    BOOL isValidatedIndex = range.location == index || NSMaxRange(range) == index;
                    if (!isValidatedIndex) {
                        NSString *logString = [NSString stringWithFormat:@"????????? ComposedCharacterSequence ????????? %@ ???????????????????????????????????????crash?????????????????????%@???(%@)???index ??? %@???????????? ComposedCharacterSequence range ??? %@", NSStringFromSelector(originCMD), selfObject, @(selfObject.length), @(index), NSStringFromRange(range)];
                        QMUIAssert(NO, @"QMUIStringSafety", @"%@", logString);
                        index = range.location;
                    }
                }
            }
            
            // call super
            NSString * (*originSelectorIMP)(id, SEL, NSUInteger);
            originSelectorIMP = (NSString * (*)(id, SEL, NSUInteger))originalIMPProvider();
            NSString * result = originSelectorIMP(selfObject, originCMD, index);
            
            return result;
        };
    });
    
    OverrideImplementation([NSString class], @selector(substringToIndex:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^NSString *(NSString *selfObject, NSUInteger index) {
            
            // index ??????
            {
                BOOL isValidatedIndex = index <= selfObject.length;
                if (!isValidatedIndex) {
                    NSString *logString = [NSString stringWithFormat:@"%@ ??????????????????????????????????????? index: %@??????????????????: %@(%@)", NSStringFromSelector(originCMD), @(index), selfObject, @(selfObject.length)];
                    QMUIAssert(NO, @"QMUIStringSafety", @"%@", logString);
                    return @"";// ?????? substringToIndex: ????????????????????? nonnull???????????? nil ????????? @"" ?????????
                }
            }
            
            // ????????? emoji ??? ComposedCharacterSequence ?????????????????????
            {
                if (index < selfObject.length) {
                    NSRange range = [selfObject rangeOfComposedCharacterSequenceAtIndex:index];
                    BOOL isValidatedIndex = range.location == index;
                    if (!isValidatedIndex) {
                        NSString *logString = [NSString stringWithFormat:@"????????? ComposedCharacterSequence ????????? %@ ???????????????????????????????????????crash?????????????????????%@???(%@)???index ??? %@???????????? ComposedCharacterSequence range ??? %@", NSStringFromSelector(originCMD), selfObject, @(selfObject.length), @(index), NSStringFromRange(range)];
                        QMUIAssert(NO, @"QMUIStringSafety", @"%@", logString);
                        index = range.location;
                    }
                }
            }
            
            // call super
            NSString * (*originSelectorIMP)(id, SEL, NSUInteger);
            originSelectorIMP = (NSString * (*)(id, SEL, NSUInteger))originalIMPProvider();
            NSString * result = originSelectorIMP(selfObject, originCMD, index);
            
            return result;
        };
    });
    
    
    // ??????????????? __NSCFConstantString ??? __NSCFString ??? NSMutableString ??? NSString????????? __NSCFString ????????? substringWithRange:????????? substring ????????????????????????????????????????????? hook __NSCFString ????????? NSString
    OverrideImplementation(NSClassFromString(@"__NSCFString"), @selector(substringWithRange:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^NSString *(NSString *selfObject, NSRange range) {
            // range ?????????????????????????????????????????????????????? (10, -8) ??? range????????? NSMaxRange ??????2???????????????????????? length ????????????????????????????????????????????????????????????????????????????????????
            {
                BOOL isValidddatedRange = NSMaxRange(range) <= selfObject.length;
                if (!isValidddatedRange) {
                    NSString *logString = [NSString stringWithFormat:@"%@ ??????????????????????????????????????? range: %@??????????????????: %@(%@)", NSStringFromSelector(originCMD), NSStringFromRange(range), selfObject, @(selfObject.length)];
                    QMUIAssert(NO, @"QMUIStringSafety", @"%@", logString);
                    return @"";// ?????? substringWithRange: ????????????????????? nonnull
                }
            }
            
            // rang ??????
            {
                NSInteger location = range.location;
                NSInteger length = range.length;
                if (location < 0 || length < 0) {
                    NSString *logString = [NSString stringWithFormat:@"%@ ????????????????????????????????????????????? range: %@??????????????????????????? (%@, %@)??????????????????: %@(%@)", NSStringFromSelector(originCMD), NSStringFromRange(range), @(location), @(length), selfObject, @(selfObject.length)];
                    QMUIAssert(NO, @"QMUIStringSafety", @"%@", logString);
//                    return @"";// ???????????????????????????????????????????????????????????????????????? return ?????????????????? assert ??????
                }
            }
            
            // ????????? emoji ??? ComposedCharacterSequence ?????????????????????
            {
                if (NSMaxRange(range) < selfObject.length) {
                    NSRange range2 = [selfObject rangeOfComposedCharacterSequencesForRange:range];
                    BOOL isValidddatedRange = range.length == 0 || NSEqualRanges(range, range2);
                    if (!isValidddatedRange) {
                        NSString *logString = [NSString stringWithFormat:@"????????? ComposedCharacterSequence ????????? %@ ???????????????????????????????????????crash?????????????????????%@???(%@)???range ??? %@???????????? ComposedCharacterSequence range ??? %@", NSStringFromSelector(originCMD), selfObject, @(selfObject.length), NSStringFromRange(range), NSStringFromRange(range2)];
                        QMUIAssert(NO, @"QMUIStringSafety", @"%@", logString);
                        range = range2;
                    }
                }
            }
            
            // call super
            NSString * (*originSelectorIMP)(id, SEL, NSRange);
            originSelectorIMP = (NSString * (*)(id, SEL, NSRange))originalIMPProvider();
            NSString * result = originSelectorIMP(selfObject, originCMD, range);
            
            return result;
        };
    });
}

+ (void)qmuisafety_NSAttributedString {
    id (^initWithStringBlock)(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) = ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^id (id selfObject, NSString *str) {
            
            str = str ?: @"";
            
            // call super
            id(*originSelectorIMP)(id, SEL, NSString *);
            originSelectorIMP = (id (*)(id, SEL, NSString *))originalIMPProvider();
            id result = originSelectorIMP(selfObject, originCMD, str);
            
            return result;
        };
    };
    
    id (^initWithStringAttributesBlock)(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) = ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        return ^id (id selfObject, NSString *str, NSDictionary<NSString *, id> *attrs) {
            
            str = str ?: @"";
            
            // call super
            id(*originSelectorIMP)(id, SEL, NSString *, NSDictionary<NSString *, id> *);
            originSelectorIMP = (id (*)(id, SEL, NSString *, NSDictionary<NSString *, id> *))originalIMPProvider();
            id result = originSelectorIMP(selfObject, originCMD, str, attrs);
            
            return result;
        };
    };
    
    // ?????????????????? init ??????????????????????????? class???????????????????????????????????????class
    OverrideImplementation([[[NSAttributedString alloc] initWithString:@""] class], @selector(initWithString:), initWithStringBlock);
    OverrideImplementation([[[NSMutableAttributedString alloc] initWithString:@""] class], @selector(initWithString:), initWithStringBlock);
    OverrideImplementation([[[NSAttributedString alloc] initWithString:@"" attributes:nil] class], @selector(initWithString:attributes:), initWithStringAttributesBlock);
    OverrideImplementation([[[NSMutableAttributedString alloc] initWithString:@"" attributes:nil] class], @selector(initWithString:attributes:), initWithStringAttributesBlock);
}

@end
