//
//  QYZYCDNTool.m
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import "QYZYCDNTool.h"

static NSDateFormatter *domianDateFormatter;

@implementation QYZYCDNTool

+ (NSString *)signatureTypeACDNWithURL:(NSString *)urlStr token:(NSString *)token typeValue:(NSInteger)typeValue {
    NSString *keyStr = nil;
    
    if (typeValue == 1) {
        keyStr = @"auth_key";
    } else if (typeValue == 2) {
        keyStr = @"sign";
    } else if (typeValue == 3) {
        keyStr = @"auth_key";
    }
    
    if (!keyStr || [urlStr containsString:[NSString stringWithFormat:@"%@=", keyStr]]) return urlStr;
    
    /// 请求短链接
    NSString *uriPath = nil;
    if ([urlStr containsString:@":"]) {
        NSURL *URL = [NSURL URLWithString:urlStr];
        
        if (URL.host.length < 1) return urlStr;
        
        NSString *hostUrl = [NSString stringWithFormat:@"%@://%@", URL.scheme, URL.host];
        uriPath = [urlStr substringFromIndex:hostUrl.length];
    } else {
        uriPath = urlStr;
    }
    
    NSString *uriPathShort = uriPath;
    if ([uriPath containsString:@"?"]) {
        uriPathShort = [[uriPath componentsSeparatedByString:@"?"] firstObject];
    }
    
    /// 随机字符串
    NSString *randomStr = [[NSString qyzy_uuid] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    randomStr = [randomStr lowercaseString];
    // 阿里authkey 随机字符串用0表示，同步安卓
    if (typeValue == 1) {
        randomStr = @"0";
    }
    /// 时间戳
    NSString *milliseconds = @([NSDate qyzy_getCurrentMillisecondTimestamp]).stringValue;
    NSInteger timeInterval = [milliseconds integerValue] / 1000;
    if (typeValue != 3) {
        timeInterval += 3600; //一小时过期时间
    }
    
    NSString *uriPathNew = [NSString stringWithFormat:@"%@-%zd-%@-0-%@", uriPathShort, timeInterval, randomStr, token];
    NSString *md5Str = [uriPathNew qyzy_md5];
    
    NSString *urlStrNew = nil;
    if ([urlStr containsString:@"?"]) {
        urlStrNew = [NSString stringWithFormat:@"%@&%@=%zd-%@-0-%@", urlStr, keyStr, timeInterval, randomStr, md5Str];
    } else {
        urlStrNew = [NSString stringWithFormat:@"%@?%@=%zd-%@-0-%@", urlStr, keyStr, timeInterval, randomStr, md5Str];
    }
    
    return urlStrNew;
}

+ (NSString *)signatureTypeBCDNWithURL:(NSString *)urlStr token:(NSString *)token typeValue:(NSInteger)typeValue {
    urlStr = [QYZYCDNTool handleUrlDateFilter:urlStr];
    /// 请求短链接
    NSString *uriPath = nil;
    NSString *hostUrl = nil;
    if ([urlStr containsString:@":"]) {
        NSURL *URL = [NSURL URLWithString:urlStr];
        
        if (URL.host.length < 1) return urlStr;
        
        hostUrl = [NSString stringWithFormat:@"%@://%@", URL.scheme, URL.host];
        uriPath = [urlStr substringFromIndex:hostUrl.length];
    } else {
        uriPath = urlStr;
    }
    
    NSString *uriPathShort = uriPath;
    if ([uriPath containsString:@"?"]) {
        uriPathShort = [[uriPath componentsSeparatedByString:@"?"] firstObject];
    }
    
    /// 时间戳
    NSString *milliseconds = @([NSDate qyzy_getCurrentMillisecondTimestamp]).stringValue;
    NSInteger timeInterval = [milliseconds integerValue] / 1000;
    NSString *dateStr = [self calcDateStrByTimestamp:timeInterval];
    
    NSString *uriPathNew = [NSString stringWithFormat:@"%@%@%@", token, dateStr, uriPathShort];
    NSString *md5Str = [uriPathNew qyzy_md5];
    
    NSString *urlStrNew = nil;
    if (hostUrl) {
        urlStrNew = [NSString stringWithFormat:@"%@/%@/%@%@", hostUrl, dateStr, md5Str, uriPath];
    } else {
        urlStrNew = [NSString stringWithFormat:@"%@/%@%@", dateStr, md5Str, uriPath];
    }
    
    return urlStrNew;
}

+ (NSString *)calcDateStrByTimestamp:(NSInteger)timeInterval {
    // 防止用户系统自定义时间过快， 导致CDN鉴权403失败, 算出来的时间倒退10分钟
    timeInterval = timeInterval - 10 * 60;
    
    NSDate *timeDate = [[NSDate alloc]initWithTimeIntervalSince1970:timeInterval];
    
    if (!domianDateFormatter) {
        domianDateFormatter = [[NSDateFormatter alloc] init];
        domianDateFormatter.dateFormat = @"yyyyMMddHHmm";
    }
    domianDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];

    NSString *timeStr = [domianDateFormatter stringFromDate:timeDate];
    return timeStr;
}

+ (NSString *)handleUrlDateFilter: (NSString *)urlStr{
    NSArray *array = [urlStr componentsSeparatedByString:@"/"];
    /**
     * 兼容传入的url会携带上次拼接的时间和md5 字段问题
     * qiutx-usercenter/getNim/accid 接口是递归调用的，会导致从第二次开始，每次传入的urlStr都会带上上次拼接的 时间 和 md5 字段
     * 这里通过检查urlStr里是否包含 “/202” 来判断是否需要兼容（如果上次加了时间，url里会有 202106261536 格式的字符串）
     * 检查出如果包含 时间 和 md5 则去除
     * 兼容前url：xxx/202106261536/12a43ec9aacdf606e927ab4102399b2a/qiutx-usercenter/getNim/accid
     * 兼容后url：xxx/qiutx-usercenter/getNim/accid
     */
    if ([urlStr containsString:@"/202"] && array.count > 4) {
        NSString *lastDateString = array[3];
        NSString *lastMD5String = array[4];
        NSString *temp = [NSString stringWithFormat:@"/%@/%@", lastDateString, lastMD5String];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:temp withString:@""];
    }
    return urlStr;
}

#pragma mark - Private Methods
+ (NSString *)dictStringWithParams:(NSDictionary *)params {
    NSDictionary *tmpDict = params;
    if ([tmpDict isKindOfClass:[NSDictionary class]] &&
        tmpDict.count) {
        return AFQueryStringFromParameters(tmpDict);;
    }
    return @"";
}


@end
