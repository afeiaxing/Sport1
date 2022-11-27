//
//  QYZYCDNTool.h
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCDNTool : NSObject

+ (NSString *)signatureTypeACDNWithURL:(NSString *)urlStr token:(NSString *)token typeValue:(NSInteger)typeValue;
+ (NSString *)signatureTypeBCDNWithURL:(NSString *)urlStr token:(NSString *)token typeValue:(NSInteger)typeValue;

@end

NS_ASSUME_NONNULL_END
