//
//  NSString+Extensions.h
//  QYZY
//
//  Created by jsmaster on 9/27/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extensions)

- (NSString *)qyzy_md5;
+ (NSString *)qyzy_uuid;
+ (NSString *)postRequestSignWithParam:(id)param
                                md5Key:(NSString *)md5Key
                          milliseconds:(NSString *)milliseconds;
+ (NSString *)getRequestSignWithParam:(id)param
                           md5Key:(NSString *)md5Key
                         milliseconds:(NSString *)milliseconds;
+ (BOOL)isEmptyString:(NSString *)string;
+ (NSString *)notEmptyFloatString:(NSString *)string length:(NSInteger)length;
+ (NSString *)spelloutStringWithNumber: (NSNumber *)number;
@end

NS_ASSUME_NONNULL_END
