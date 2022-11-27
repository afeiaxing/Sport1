//
//  NSString+Extensions.m
//  QYZY
//
//  Created by jsmaster on 9/27/22.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extensions)

- (NSString *)qyzy_md5 {
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self qyzy_stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)qyzy_stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}

+ (NSString *)qyzy_uuid{
    // create a new UUID which you own
    CFUUIDRef uuidref = CFUUIDCreate(kCFAllocatorDefault);
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    CFStringRef uuid = CFUUIDCreateString(kCFAllocatorDefault, uuidref);
    NSString *result = (__bridge NSString *)uuid;
    //release the uuidref
    CFRelease(uuidref);
    // release the UUID
    CFRelease(uuid);
    return result;
}

+ (NSString *)postRequestSignWithParam:(id)param
                                md5Key:(NSString *)md5Key
                          milliseconds:(NSString *)milliseconds {
    NSString * keyValueStr;
    if (param) {
        NSError * parseError = nil;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:param options:kNilOptions error:&parseError];
        keyValueStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        keyValueStr = [NSString stringWithFormat:@"%@&key=%@",keyValueStr,md5Key];
    } else {
        keyValueStr = [NSString stringWithFormat:@"key=%@", md5Key];
    }
    keyValueStr = [NSString stringWithFormat:@"%@&t=%@",keyValueStr,milliseconds];

    return [[keyValueStr qyzy_md5] qyzy_sha1String];
}

+ (NSString *)getRequestSignWithParam:(id)param
                           md5Key:(NSString *)md5Key
                     milliseconds:(NSString *)milliseconds {

    NSMutableArray * keyValues = @[].mutableCopy;
    if ([param isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)param;
        NSArray * allKeyArray = [dict allKeys];
        NSArray * afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSComparisonResult result = [obj1 compare:obj2];
            return result;
        }];
        /// 通过排列的key值获取value
        NSMutableArray * valueArray = [NSMutableArray array];
        for (NSString * sortsing in afterSortKeyArray) {
            NSString * valueString = [dict objectForKey:sortsing];
            [valueArray addObject:valueString];
        }
        
        [afterSortKeyArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
            [keyValues addObject:[NSString stringWithFormat:@"%@=%@", key, valueArray[idx]]];
        }];
    }

    if (md5Key) {
        [keyValues addObject:[NSString stringWithFormat:@"key=%@", md5Key]];
    }
    if (milliseconds) {
        [keyValues addObject:[NSString stringWithFormat:@"t=%@", milliseconds]];
    }
    NSString * keyValueStr = [keyValues componentsJoinedByString:@"&"];
    return [[keyValueStr qyzy_md5] qyzy_sha1String];
}

- (NSString *)qyzy_sha1String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(string, length, bytes);
    return [self qyzy_stringFromBytes:bytes length:CC_SHA1_DIGEST_LENGTH];
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

+ (NSString *)notEmptyFloatString:(NSString *)string length:(NSInteger)length {
    if ([NSString isEmptyString:string]) {
        return @"-";
    }
    NSString *format = [NSString stringWithFormat:@"%%.%ldf",length];
    return [NSString stringWithFormat:format,string.floatValue];
}

+ (NSString *)spelloutStringWithNumber: (NSNumber *)number {
    NSInteger num = number.integerValue;
    NSInteger tenThousand = 10000;
    NSInteger hundredMillion = 100000000;

    if (num < 0) {
        return @"0";
    } else if (num < tenThousand) {
        return number.stringValue;
    } else if (num < hundredMillion) {
        return [NSString stringWithFormat:@"%.1f万", (float)num / tenThousand];
    } else {
        return [NSString stringWithFormat:@"%.1f亿", (float)num / hundredMillion];
    }

    return @"";
}

@end
