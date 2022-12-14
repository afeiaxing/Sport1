/**
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2021 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 */

//
//  UILabel+QMUI.m
//  qmui
//
//  Created by QMUI Team on 15/7/20.
//

#import "UILabel+QMUI.h"
#import "QMUICore.h"
#import "NSParagraphStyle+QMUI.h"
#import "NSObject+QMUI.h"
#import "NSNumber+QMUI.h"
#import "CALayer+QMUI.h"
#import "UIView+QMUI.h"

const CGFloat QMUILineHeightIdentity = -1000;

@interface UILabel ()

@property(nonatomic, strong) CAShapeLayer *qmuilb_principalLineLayer;
@end

@implementation UILabel (QMUI)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selectors[] = {
            @selector(setText:),
            @selector(setAttributedText:),
            @selector(setLineBreakMode:),
            @selector(setTextAlignment:),
        };
        for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); index++) {
            SEL originalSelector = selectors[index];
            SEL swizzledSelector = NSSelectorFromString([@"qmuilb_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
            ExchangeImplementations([self class], originalSelector, swizzledSelector);
        }
    });
}

- (void)qmuilb_setText:(NSString *)text {
    if (!text) {
        [self qmuilb_setText:text];
        return;
    }
    if (!self.qmui_textAttributes.count && ![self _hasSetQmuiLineHeight]) {
        [self qmuilb_setText:text];
        return;
    }
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:text attributes:self.qmui_textAttributes];
    [self qmuilb_setAttributedText:[self attributedStringWithKernAndLineHeightAdjusted:attributedString]];
}

// ??? qmui_textAttributes ???????????????????????????????????? attributedString ???????????????????????????????????????????????????????????????????????????????????? attributedText ??????
- (void)qmuilb_setAttributedText:(NSAttributedString *)text {
    if (!text || (!self.qmui_textAttributes.count && ![self _hasSetQmuiLineHeight])) {
        [self qmuilb_setAttributedText:text];
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text.string attributes:self.qmui_textAttributes];
    attributedString = [[self attributedStringWithKernAndLineHeightAdjusted:attributedString] mutableCopy];
    [text enumerateAttributesInRange:NSMakeRange(0, text.length) options:0 usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        [attributedString addAttributes:attrs range:range];
    }];
    [self qmuilb_setAttributedText:attributedString];
}

static char kAssociatedObjectKey_textAttributes;
// ?????????????????????????????? qmui_textAttributes ????????????????????????????????????????????????????????????????????? qmui_textAttributes ??????
- (void)setQmui_textAttributes:(NSDictionary<NSAttributedStringKey, id> *)qmui_textAttributes {
    NSDictionary *prevTextAttributes = self.qmui_textAttributes;
    if ([prevTextAttributes isEqualToDictionary:qmui_textAttributes]) {
        return;
    }
    
    objc_setAssociatedObject(self, &kAssociatedObjectKey_textAttributes, qmui_textAttributes, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (!self.text.length) {
        return;
    }
    NSMutableAttributedString *string = [self.attributedText mutableCopy];
    NSRange fullRange = NSMakeRange(0, string.length);
    
    // 1????????? attributedText ???????????????????????????????????????????????? qmui_textAttributes ?????????????????????????????? attributedString ???????????????????????????????????????????????????????????????????????????????????????
    if (prevTextAttributes) {
        // ???????????? attributedText ????????? attrs ?????????????????? qmui_textAttributes ?????????
        NSMutableArray *willRemovedAttributes = [NSMutableArray array];
        [string enumerateAttributesInRange:NSMakeRange(0, string.length) options:0 usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            // ???????????? kern ?????????????????? range ???????????????????????????????????????????????????????????? qmui_textAttribtus ?????????
            if (NSEqualRanges(range, NSMakeRange(0, string.length - 1)) && [attrs[NSKernAttributeName] isEqualToNumber:prevTextAttributes[NSKernAttributeName]]) {
                [string removeAttribute:NSKernAttributeName range:NSMakeRange(0, string.length - 1)];
            }
            // ??????????????? kern ?????????????????? range ????????????????????????????????????????????? qmui_textAttributes ?????????
            if (!NSEqualRanges(range, fullRange)) {
                return;
            }
            [attrs enumerateKeysAndObjectsUsingBlock:^(NSAttributedStringKey _Nonnull attr, id  _Nonnull value, BOOL * _Nonnull stop) {
                if (prevTextAttributes[attr] == value) {
                    [willRemovedAttributes addObject:attr];
                }
            }];
        }];
        [willRemovedAttributes enumerateObjectsUsingBlock:^(id  _Nonnull attr, NSUInteger idx, BOOL * _Nonnull stop) {
            [string removeAttribute:attr range:fullRange];
        }];
    }
    
    // 2??????????????????
    if (qmui_textAttributes) {
        [string addAttributes:qmui_textAttributes range:fullRange];
    }
    // ???????????? setAttributedText: ????????????????????????????????????????????????????????????????????? NSAttributedString ???????????? qmui_textAttributes ?????????
    [self qmuilb_setAttributedText:[self attributedStringWithKernAndLineHeightAdjusted:string]];
}

- (NSDictionary *)qmui_textAttributes {
    return (NSDictionary *)objc_getAssociatedObject(self, &kAssociatedObjectKey_textAttributes);
}

// ???????????????????????? kern ????????????????????????????????????????????? qmui_setLineHeight: ???????????????
- (NSAttributedString *)attributedStringWithKernAndLineHeightAdjusted:(NSAttributedString *)string {
    if (!string.length) {
        return string;
    }
    NSMutableAttributedString *attributedString = nil;
    if ([string isKindOfClass:[NSMutableAttributedString class]]) {
        attributedString = (NSMutableAttributedString *)string;
    } else {
        attributedString = [string mutableCopy];
    }
    
    // ???????????????????????? kern ?????????????????????????????????????????????
    // ????????? qmui_textAttributes ???????????? kern ???????????????????????????
    if (self.qmui_textAttributes[NSKernAttributeName]) {
        [attributedString removeAttribute:NSKernAttributeName range:NSMakeRange(string.length - 1, 1)];
    }
    
    // ????????????????????????????????? qmui_setLineHeight: ???????????????
    __block BOOL shouldAdjustLineHeight = [self _hasSetQmuiLineHeight];
    [attributedString enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, attributedString.length) options:0 usingBlock:^(NSParagraphStyle *style, NSRange range, BOOL * _Nonnull stop) {
        // ?????????????????????????????? NSParagraphStyle ??????????????? range ??????????????????????????????????????????????????????
        if (NSEqualRanges(range, NSMakeRange(0, attributedString.length))) {
            if (style && (style.maximumLineHeight || style.minimumLineHeight)) {
                shouldAdjustLineHeight = NO;
                *stop = YES;
            }
        }
    }];
    if (shouldAdjustLineHeight) {
        NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:self.qmui_lineHeight lineBreakMode:self.lineBreakMode textAlignment:self.textAlignment];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, attributedString.length)];
        
        // iOS ?????????????????????????????????????????????????????????????????????????????? label ???????????????
        CGFloat baselineOffset = (self.qmui_lineHeight - self.font.lineHeight) / 4;// ?????????????????????baseline + 1???????????????????????? 2pt?????????????????????????????????????????? / 4???
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset) range:NSMakeRange(0, attributedString.length)];
    }
    
    return attributedString;
}

- (void)qmuilb_setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    [self qmuilb_setLineBreakMode:lineBreakMode];
    if (!self.qmui_textAttributes) return;
    if (self.qmui_textAttributes[NSParagraphStyleAttributeName]) {
        NSMutableParagraphStyle *p = ((NSParagraphStyle *)self.qmui_textAttributes[NSParagraphStyleAttributeName]).mutableCopy;
        p.lineBreakMode = lineBreakMode;
        NSMutableDictionary<NSAttributedStringKey, id> *attrs = self.qmui_textAttributes.mutableCopy;
        attrs[NSParagraphStyleAttributeName] = p.copy;
        self.qmui_textAttributes = attrs.copy;
    }
}

- (void)qmuilb_setTextAlignment:(NSTextAlignment)textAlignment {
    [self qmuilb_setTextAlignment:textAlignment];
    if (!self.qmui_textAttributes) return;
    if (self.qmui_textAttributes[NSParagraphStyleAttributeName]) {
        NSMutableParagraphStyle *p = ((NSParagraphStyle *)self.qmui_textAttributes[NSParagraphStyleAttributeName]).mutableCopy;
        p.alignment = textAlignment;
        NSMutableDictionary<NSAttributedStringKey, id> *attrs = self.qmui_textAttributes.mutableCopy;
        attrs[NSParagraphStyleAttributeName] = p.copy;
        self.qmui_textAttributes = attrs.copy;
    }
}

static char kAssociatedObjectKey_lineHeight;
- (void)setQmui_lineHeight:(CGFloat)qmui_lineHeight {
    if (qmui_lineHeight == QMUILineHeightIdentity) {
        objc_setAssociatedObject(self, &kAssociatedObjectKey_lineHeight, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    } else {
        objc_setAssociatedObject(self, &kAssociatedObjectKey_lineHeight, @(qmui_lineHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    // ??????????????? UILabel????????????????????? text?????? attributedText ?????????????????????????????????????????? setText ?????? setAttributedText
    // ????????????????????????????????? qmui_textAttributes ??? text ???????????????????????????????????? lineHeight ?????????????????????
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.attributedText.string attributes:self.qmui_textAttributes];
    attributedString = [[self attributedStringWithKernAndLineHeightAdjusted:attributedString] mutableCopy];
    [self setAttributedText:attributedString];
}

- (CGFloat)qmui_lineHeight {
    if ([self _hasSetQmuiLineHeight]) {
        return [(NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_lineHeight) qmui_CGFloatValue];
    } else if (self.attributedText.length) {
        __block NSMutableAttributedString *string = [self.attributedText mutableCopy];
        __block CGFloat result = 0;
        [string enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, string.length) options:0 usingBlock:^(NSParagraphStyle *style, NSRange range, BOOL * _Nonnull stop) {
            // ?????????????????????????????? NSParagraphStyle ??????????????? range ??????????????????????????????????????????????????????
            if (NSEqualRanges(range, NSMakeRange(0, string.length))) {
                if (style && (style.maximumLineHeight || style.minimumLineHeight)) {
                    result = style.maximumLineHeight;
                    *stop = YES;
                }
            }
        }];
        
        return result == 0 ? self.font.lineHeight : result;
    } else if (self.text.length) {
        return self.font.lineHeight;
    } else if (self.qmui_textAttributes) {
        // ?????? label ???????????????????????????????????? qmui_textAttributes ?????????
        if ([self.qmui_textAttributes.allKeys containsObject:NSParagraphStyleAttributeName]) {
            return ((NSParagraphStyle *)self.qmui_textAttributes[NSParagraphStyleAttributeName]).minimumLineHeight;
        } else if ([self.qmui_textAttributes.allKeys containsObject:NSFontAttributeName]) {
            return ((UIFont *)self.qmui_textAttributes[NSFontAttributeName]).lineHeight;
        }
    }
    
    return 0;
}

- (BOOL)_hasSetQmuiLineHeight {
    return !!objc_getAssociatedObject(self, &kAssociatedObjectKey_lineHeight);
}

- (instancetype)qmui_initWithFont:(UIFont *)font textColor:(UIColor *)textColor {
    BeginIgnoreClangWarning(-Wunused-value)
    [self init];
    EndIgnoreClangWarning
    self.font = font;
    self.textColor = textColor;
    return self;
}

- (void)qmui_setTheSameAppearanceAsLabel:(UILabel *)label {
    self.font = label.font;
    self.textColor = label.textColor;
    self.backgroundColor = label.backgroundColor;
    self.lineBreakMode = label.lineBreakMode;
    self.textAlignment = label.textAlignment;
    if ([self respondsToSelector:@selector(setContentEdgeInsets:)] && [label respondsToSelector:@selector(contentEdgeInsets)]) {
        UIEdgeInsets contentEdgeInsets;
        [label qmui_performSelector:@selector(contentEdgeInsets) withPrimitiveReturnValue:&contentEdgeInsets];
        [self qmui_performSelector:@selector(setContentEdgeInsets:) withArguments:&contentEdgeInsets, nil];
    }
}

- (void)qmui_calculateHeightAfterSetAppearance {
    self.text = @"???";
    [self sizeToFit];
    self.text = nil;
}

- (void)qmui_avoidBlendedLayersIfShowingChineseWithBackgroundColor:(UIColor *)color {
    self.opaque = YES;// ??????????????????YES??????????????????????????????
    self.backgroundColor = color;
    self.clipsToBounds = YES;// ??? clip ????????? cornerRadius???????????????offscreen render
}

@end

@implementation UILabel (QMUI_Debug)

QMUISynthesizeIdStrongProperty(qmuilb_principalLineLayer, setQmuilb_principalLineLayer)
QMUISynthesizeIdStrongProperty(qmui_principalLineColor, setQmui_principalLineColor)

static char kAssociatedObjectKey_showPrincipalLines;
- (void)setQmui_showPrincipalLines:(BOOL)qmui_showPrincipalLines {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_showPrincipalLines, @(qmui_showPrincipalLines), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (qmui_showPrincipalLines && !self.qmuilb_principalLineLayer) {
        self.qmuilb_principalLineLayer = [CAShapeLayer layer];
        [self.qmuilb_principalLineLayer qmui_removeDefaultAnimations];
        self.qmuilb_principalLineLayer.strokeColor = (self.qmui_principalLineColor ?: UIColorTestRed).CGColor;
        self.qmuilb_principalLineLayer.lineWidth = PixelOne;
        [self.layer addSublayer:self.qmuilb_principalLineLayer];
        
        if (!self.qmui_layoutSubviewsBlock) {
            self.qmui_layoutSubviewsBlock = ^(UILabel * _Nonnull label) {
                if (!label.qmuilb_principalLineLayer || label.qmuilb_principalLineLayer.hidden)  return;
                
                label.qmuilb_principalLineLayer.frame  = label.bounds;
                
                NSRange range = NSMakeRange(0, label.attributedText.length);
                CGFloat baselineOffset = [[label.attributedText attribute:NSBaselineOffsetAttributeName atIndex:0 effectiveRange:&range] doubleValue];
                CGFloat lineOffset = baselineOffset * 2;
                UIFont *font = label.font;
                CGFloat maxX = CGRectGetWidth(label.bounds);
                CGFloat maxY = CGRectGetHeight(label.bounds);
                CGFloat descenderY = maxY + font.descender - lineOffset;
                CGFloat xHeightY = maxY - (font.xHeight - font.descender) - lineOffset;
                CGFloat capHeightY = maxY - (font.capHeight - font.descender) - lineOffset;
                CGFloat lineHeightY = maxY - font.lineHeight - lineOffset;
                
                void (^addLineAtY)(UIBezierPath *, CGFloat) = ^void(UIBezierPath *p, CGFloat y) {
                    CGFloat offset = PixelOne / 2;
                    y = flat(y) - offset;
                    [p moveToPoint:CGPointMake(0, y)];
                    [p addLineToPoint:CGPointMake(maxX, y)];
                };
                UIBezierPath *path = [UIBezierPath bezierPath];
                addLineAtY(path, descenderY);
                addLineAtY(path, xHeightY);
                addLineAtY(path, capHeightY);
                addLineAtY(path, lineHeightY);
                label.qmuilb_principalLineLayer.path = path.CGPath;
            };
        }
    }
    self.qmuilb_principalLineLayer.hidden = !qmui_showPrincipalLines;
}

- (BOOL)qmui_showPrincipalLines {
    return [((NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_showPrincipalLines)) boolValue];
}

@end
