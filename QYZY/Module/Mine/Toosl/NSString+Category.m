//
//  NSString+Category.m
//  IhaveCar
//
//  Created by LuYiHuang on 14-9-16.
//  Copyright (c) 2014年 qiyiyi. All rights reserved.
//

#import "NSString+Category.h"


@implementation NSString (Category)

/// 图片URL追加imgsize
- (NSString *)appendImageUrlSize:(CGSize)imgSize {
    if (CGSizeEqualToSize(imgSize, CGSizeZero) ||
        [self containsString:@".gif"]) return self;
    
    if ([self containsString:@"?"]) {
        return [NSString stringWithFormat:@"%@&x-image-process=image/resize,m_fill,h_%.0f,w_%.0f", self, imgSize.height * [UIScreen mainScreen].scale, imgSize.width * [UIScreen mainScreen].scale];
    } else {
        return [NSString stringWithFormat:@"%@?x-image-process=image/resize,m_fill,h_%.0f,w_%.0f", self, imgSize.height * [UIScreen mainScreen].scale, imgSize.width * [UIScreen mainScreen].scale];
    }
}

/**
 * 宽度计算
 */
- (float)getWidthWithFont:(UIFont *)font maxWidth:(float)maxWidth {
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGFloat width = [self boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:font} context:nil].size.width;
    return width;
}

/**
 * 高度计算
 */
- (float)getHeightWithFont:(UIFont *)font widthLimit:(float)widthLimit {
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGFloat height = [self boundingRectWithSize:CGSizeMake(widthLimit, CGFLOAT_MAX) options:options attributes:@{NSFontAttributeName:font} context:nil].size.height;
    return height;
}

+ (BOOL)isEmptyString:(NSString *)string {
    if (nil == string
        || NULL == string
        || [@"NULL" isEqualToString:string]
        || [@"<null>" isEqualToString:string]
        || [@"(null)" isEqualToString:string]
        || [@"null" isEqualToString:string]) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) return YES;
    NSString *resStr = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return resStr.length <= 0;
}

/// 验证字符串数组是否相等
+ (BOOL)validateStrArray:(NSArray<NSString *> *)strArray1 isEqualToStrArray:(NSArray<NSString *> *)strArray2 {
    if (!strArray1 || !strArray2) {
        return NO;
    }
    
    if (strArray1.count != strArray2.count) {
        return NO;
    }
    
    for (NSInteger idx = 0; idx < strArray1.count; idx ++) {
        NSString *str1 = [strArray1 objectAtIndex:idx];
        NSString *str2 = [strArray2 objectAtIndex:idx];
        if (![str1 isEqualToString:str2]) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark 获取带有不同样式的文字内容
+ (NSAttributedString *)xm_attributedString:(NSArray*)stringArray attributeArray:(NSArray *)attributeArray {
    // 定义要显示的文字内容
    NSString *string = [stringArray componentsJoinedByString:@""]; // 拼接传入的字符串数组
    // 通过要显示的文字内容来创建一个带属性样式的字符串对象
    NSMutableAttributedString * result = [[NSMutableAttributedString alloc] initWithString:string];
    for(NSInteger i = 0; i < stringArray.count; i++){
        // 将某一范围内的字符串设置样式
        [result setAttributes:attributeArray[i] range:[string rangeOfString:stringArray[i]]];
    }
    // 返回已经设置好了的带有样式的文字
    return [[NSAttributedString alloc] initWithAttributedString:result];
}

/**
 *  根据字体和宽度计算文本Size
 *
 *  @author LuYiHuang
 *  @date 2014-10-27 18:06:56
 *
 *  @param font  字体
 *  @param width 宽度
 *
 *  @return 文本CGSize
 */
- (CGSize)textSize:(UIFont*)font withWidth:(CGFloat)width
{
    
    CGSize contentSize = CGSizeZero;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{ NSFontAttributeName : font,
                                   NSParagraphStyleAttributeName : paragraphStyle };
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    contentSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:options
                                  attributes:attributes
                                     context:nil].size;
#else
    contentSize = [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#endif
    return contentSize;
}

/**
 * 缩略显示字符串
 * @param length 显示长度
 */
- (NSString *)abbreviationTitleWithLenth:(NSInteger)length {
    if (self.length > length) {
        NSString *subString = [self substringToIndex:length];
        subString = [NSString stringWithFormat:@"%@...",subString];
        return subString;
    }
    return self;
}

+ (NSString *)getNumberFromStr:(NSString *)str {
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    return[[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
}

+ (BOOL)isNumberClass:(NSString *)string {
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    return string.length == 0;
}


- (NSString *)emojiEncode {
    NSString *string = [NSString stringWithUTF8String:[self UTF8String]];
    NSData *data = [string dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)emojiDecode {
    const char *string = [self UTF8String];
    NSData *data = [NSData dataWithBytes:string length:strlen(string)];
    return [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
}

- (NSString *)xm_likeCountChange{
    NSInteger count = self.integerValue;
    if (count >= 10000) {
        return [NSString stringWithFormat:@"%0.0ld万+",count / 10000];
    }else{
        return self;
    }
}

- (NSString *)xm_likeIntCountChange{
    NSInteger count = self.integerValue;
    if (count >= 10000) {
        return [NSString stringWithFormat:@"%0.0ld万",count / 10000];
    }else{
        return self;
    }
}

- (NSString *)xm_likeIntCountChange:(BOOL)isPenny {
    NSInteger x = isPenny ? 10000000 : 100000;
    CGFloat count = self.integerValue;
    if (count > x) {
        /// 因为要保留一位小数并且向下取整
        NSInteger temp = count / (isPenny ? 100000 : 1000);
        return [NSString stringWithFormat:@"%.1fW",@(temp).floatValue / 10];
    }else{
        return isPenny ? [NSString stringWithFormat:@"%.0f",count / 100] : self;
    }
}

// 计算 字符串 中文长度
- (NSUInteger)xm_ChineseLength {
    NSString *regexStr = @"[0-9\\u4e00-\\u9fa5]+";

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSArray<NSTextCheckingResult *> * results = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    NSUInteger length = 0;
    for (NSTextCheckingResult *result in results) {
        length += result.range.length;
    }
    return length;
}


// 获取 字符串 长度 （一个字符一个字节 一个汉字2个字节）
- (NSUInteger)xm_stringGBLength {
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *data = [self dataUsingEncoding:encoding];
    NSUInteger length = [data length];
    return length;
}

// 调用 UTF8 编码处理 (一个字符一个字节 一个汉字3个字节 一个表情4个字节)
- (NSUInteger)xm_stringUtf8Length {
    return [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

// 是否 包含 汉字
- (BOOL)xm_containChinese {
    for(int i=0; i< [self length];i++) {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
- (NSString *)xm_safeSubstringToIndex:(NSInteger)index
{
    if (self.length >= index) {
        return [self substringToIndex:index];
    }else{
        return self;
    }
}
- (NSString *)xm_addPer
{
    if (![self hasSuffix:@"%%"]) {
        NSString *per = [NSString stringWithFormat:@"%.1f",self.floatValue*100];
        return [NSString stringWithFormat:@"%@%%",per];
    }else{
        return self;
    }
}

- (NSString *)xm_onlyAddPerCent
{
    if (![self hasSuffix:@"%%"]) {
        return [NSString stringWithFormat:@"%@%%",self];
    }else{
        return self;
    }
}

+ (NSString *)xm_transPercentStringWithString:(NSString *)string
{
    if ([NSString isEmptyString:string]) {
        return @"-";
    }
    return [string xm_addPer];
}


+ (NSString *)xm_notEmptyStringWith:(NSString *)string
{
    if ([NSString isEmptyString:string]) {
        return @"-";
    }
    return string;
}


+ (NSString *)xm_notEmptyFloatStringWith:(NSString *)string decimalLen:(NSInteger)len
{
    if ([NSString isEmptyString:string]) {
        return @"-";
    }
    NSString *format = [NSString stringWithFormat:@"%%.%ldf",len];
    return [NSString stringWithFormat:format,string.floatValue];
}

//ASCII码0.5长度 中文1长度
- (CGFloat)xm_stringCharacterLength {
    CGFloat n = [self length];
    int l = 0;
    int a = 0;
    int b = 0;
    CGFloat wLen = 0;
    unichar c;
    for(int i = 0; i < n; i++){
        c = [self characterAtIndex:i];//按顺序取出单个字符
        if(isblank(c)){//判断字符串为空或为空格
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
        wLen = l+(CGFloat)((CGFloat)(a+b)/2.0);
    }
    if(a==0 && l==0) {
        return 0;//只有isblank
    } else{
        return wLen;//长度，中文占1，英文等能转ascii的占0.5
    }
}

- (NSString *)xm_substringToIndex:(NSUInteger)index {
    CGFloat n = [self length];
    int l = 0;
    int a = 0;
    int b = 0;
    CGFloat wLen = 0;
    unichar c;
    for(int i = 0; i < n; i++){
        c = [self characterAtIndex:i];//按顺序取出单个字符
        if(isblank(c)){//判断字符串为空或为空格
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
        //中文为1 ASCII为0.5 计算出最终长度
        wLen = l+(CGFloat)((CGFloat)(a+b)/2.0);
        if (wLen >= index) {
            break;
        }
    }
    NSString *finalStr;
    //以允许输入7个汉字（14个ASCII字符）为例 如果中英文混合输入 自动计算长度（中文占俩 英文占一个）
    //前面已经有13个字符了 第十四个输入字母时 允许输入
    if (((int)(wLen * 2)) % 2 == 0) {
        finalStr = [self substringToIndex:a + b + l];
    }else{
    //第十四个字符输入汉字时 不允许输入了 因为汉字占俩字符 允许输入的话 就变成15个 超出了14个规定范围
        finalStr = [self substringToIndex:a + b + l - 1];
    }
    return finalStr;
}

- (NSArray *)words
{
#if ! __has_feature(objc_arc)
    NSMutableArray *words = [[[NSMutableArray alloc] init] autorelease];
#else
    NSMutableArray *words = [[NSMutableArray alloc] init];
#endif
 
    const char *str = [self cStringUsingEncoding:NSUTF8StringEncoding];
 
    char *word;
    for (int i = 0; i < strlen(str);) {
        int len = 0;
        if (str[i] >= 0xFFFFFFFC) {
            len = 6;
        } else if (str[i] >= 0xFFFFFFF8) {
            len = 5;
        } else if (str[i] >= 0xFFFFFFF0) {
            len = 4;
        } else if (str[i] >= 0xFFFFFFE0) {
            len = 3;
        } else if (str[i] >= 0xFFFFFFC0) {
            len = 2;
        } else if (str[i] >= 0x00) {
            len = 1;
        }
 
        word = malloc(sizeof(char) * (len + 1));
        for (int j = 0; j < len; j++) {
            word[j] = str[j + i];
        }
        word[len] = '\0';
        i = i + len;
 
        NSString *oneWord = [NSString stringWithCString:word encoding:NSUTF8StringEncoding];
        free(word);
        [words addObject:oneWord];
    }
 
    return words;
}

+ (NSAttributedString *)xm_attributedShadowStringWithString:(NSString *)string
                                                shadowColor:(UIColor *)shadowColor
                                               shadowOffset:(CGSize)shadowOffset
                                           shadowBlurRadius:(CGFloat)shadowBlurRadius {
    if (!string.length) {
        return [[NSMutableAttributedString alloc]initWithString:@""];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:string];

    NSShadow *shadow = [[NSShadow alloc]init];

    shadow.shadowBlurRadius = shadowBlurRadius;

    shadow.shadowOffset = shadowOffset;

    shadow.shadowColor = shadowColor;

    [attributedString addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

@end
