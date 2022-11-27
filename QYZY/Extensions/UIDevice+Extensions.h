//
//  UIDevice+Extension.h
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (Extensions)

+ (NSString *)qyzy_appVersion;
+ (NSString *)qyzy_getDeviceID;

@end



@interface KeyChainStore : NSObject

// 将UUID保存到钥匙串
+ (void)save:(NSString *)service data:(id)data;
// 读取保存到钥匙串的UUID
+ (id)load:(NSString *)service;
// 删除保存到钥匙串的UUID
+ (void)deleteKeyData:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
