//
//  XMDomainProvider.h
//  XMSport
//
//  Created by jsmaster on 8/20/22.
//  Copyright © 2022 XMSport. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYZYDomainDowngradeModel.h"
#import "QYZYDomain.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const XMDomainAvaliableNotification;
FOUNDATION_EXPORT NSString * const XMDomainAvaliableNotificationDomainKey;

@interface QYZYDomainProvider : NSObject

+ (instancetype)shareInstance;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/// 设置请求更多域名规则
/// @param models 域名降级模型数组
- (void)addDomainDowngradeModels:(NSArray <QYZYDomainDowngradeModel *> *)models;

///  添加域名
/// @param domains 域名数组
- (void)addDomains:(NSArray <QYZYDomain *> *)domains;


/// 立即返回一个最合适的域名， 并不一定可用
/// @param forWeight 是否是因为权重而获取域名
- (QYZYDomain *)getDomainInstantlyForWeight:(BOOL)forWeight;

/// 清除缓存
- (void)clearMemoryAndFile;

/// 域名检测，
- (void)checkDomains;

/// 获取域名对应的域名模型
- (QYZYDomain *)getDomainModelWithURL:(NSString *)URL;

#pragma mark - 单元测试需要
- (NSUInteger)getDomainCount;

@end

NS_ASSUME_NONNULL_END
