//
//  NSString+Category.h
//  IhaveCar
//
//  Created by LuYiHuang on 14-9-16.
//  Copyright (c) 2014年 qiyiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

/// 图片URL追加imgsize
- (NSString *)appendImageUrlSize:(CGSize)imgSize;

/// 宽度计算
- (float)getWidthWithFont:(UIFont *)font maxWidth:(float)maxWidth;

/// 高度计算
- (float)getHeightWithFont:(UIFont *)font widthLimit:(float)widthLimit;

/* 判断字符串是否为空 */
+ (BOOL)isEmptyString:(NSString *)string;

/* 验证字符串数组是否相等 */
+ (BOOL)validateStrArray:(NSArray<NSString *> *)strArray1 isEqualToStrArray:(NSArray<NSString *> *)strArray2;

/* 获取带有不同样式的文字内容 */
+ (NSAttributedString *)xm_attributedString:(NSArray*)stringArray attributeArray:(NSArray *)attributeArray;

/**
 *  根据字体和宽度计算文本Size
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 文本CGSize
 */
- (CGSize)textSize:(UIFont*)font withWidth:(CGFloat)width;

/**
 * 缩略显示字符串
 * @param length 显示长度
 */
- (NSString *)abbreviationTitleWithLenth:(NSInteger)length;

/** 是否是数字 */
+ (BOOL)isNumberClass:(NSString *)string;


/** 获取字符串中数字 */
+ (NSString *)getNumberFromStr:(NSString *)str;

- (NSString *)emojiEncode;

- (NSString *)emojiDecode;

//ASCII码0.5长度 中文1长度
- (CGFloat)xm_stringCharacterLength;

/// 依据 index 截取 字符串
/// @param index 截取 索引
- (NSString *)xm_substringToIndex:(NSUInteger)index;

/// 计算 字符串 中文长度
- (NSUInteger)xm_ChineseLength;

/// 获取 字符串 长度
/// （一个字符一个字节 一个汉字2个字节）
- (NSUInteger)xm_stringGBLength;


/// 调用 UTF8 编码处理
/// (一个字符一个字节 一个汉字3个字节 一个表情4个字节)
- (NSUInteger)xm_stringUtf8Length;


/// 是否 包含 汉字
- (BOOL)xm_containChinese;

/// 点赞数量过万转换
/// title为数字点赞数量，超过一万的除一万的结果   万+
- (NSString *)xm_likeCountChange;

/// 点赞数量过万转换
/// title为数字点赞数量，超过一万的除一万的结果   万
- (NSString *)xm_likeIntCountChange;

/// 点赞数量过万转换
/// title为数字点赞数量，超过一万的除一万的结果   万
- (NSString *)xm_likeIntCountChange:(BOOL)isPenny;

/// 亚盘盘口转化 0.25 -> 0/0.5 , 0.75 -> 0.5/1
+ (NSString *)changeWithOvalueNum:(NSString *)ovalueStr;

/// 截取前n位，如果要截取的长度比实际长度大，直接返回原字符串
- (NSString *)xm_safeSubstringToIndex:(NSInteger)index;

/// 在末尾添加%，如果已经有%则不添加
- (NSString *)xm_addPer;
/// 在末尾添加%，如果已经有%则不添加(只添加%)
- (NSString *)xm_onlyAddPerCent;
/// 将字符串统一处理，如果是nil或空字符串，统一返回-，否则返回字符串本身
/// @param string 要转换的字符串
+ (NSString *)xm_notEmptyStringWith:(NSString *)string;
/// 转变为 百分号 字符串
/// @param string 百分号
+ (NSString *)xm_transPercentStringWithString:(NSString *)string;
/// format小数位，没有内容显示-
+ (NSString *)xm_notEmptyFloatStringWith:(NSString *)string decimalLen:(NSInteger)len;
/// 获取单个字符数组
- (NSArray *)words;
///  获取带有阴影的富文本
+ (NSAttributedString *)xm_attributedShadowStringWithString:(NSString *)string
                                                shadowColor:(UIColor *)shadowColor
                                               shadowOffset:(CGSize)shadowOffset
                                           shadowBlurRadius:(CGFloat)shadowBlurRadius;
@end

static inline NSString * xm_notEemptyFloat(NSString * _Nullable data,NSInteger decimalLen) {
    return [NSString xm_notEmptyFloatStringWith:data decimalLen:decimalLen];
}

static inline NSString * _Nullable handleDouble(NSString * _Nullable value) {
    if ([value isKindOfClass:NSString.class] && value.length) {
        double num = [value doubleValue];
        NSString *dstr = [NSString stringWithFormat:@"%f",num];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dstr];
        return dn.stringValue;
    }
    else {
        return value;
    }
}
