//
//  XMDomain.h
//  XMSport
//
//  Created by jsmaster on 8/20/22.
//  Copyright © 2022 XMSport. All rights reserved.
//

#import <Foundation/Foundation.h>

/// CDN类型的base64表现形式
#define XMDomainCDNTypeAName    @"YWxpeXVu"
#define XMDomainCDNTypeTName    @"dGVuY2VudA=="
#define XMDomainCDNTypeHName    @"aHc="
#define XMDomainCDNTypeFName    @"ZnVubnVsbA=="

FOUNDATION_EXPORT NSInteger const XMDeaultDomainTimeConsume;
FOUNDATION_EXPORT NSInteger const XMDeaultFailDomainTimeConsume;

typedef NS_ENUM(NSInteger, XMDomainCDNType) {
    XMDomainCDNTypeFunnull = 0, // 方能 A8等CDN
    XMDomainCDNTypeA, // 阿里CDN
    XMDomainCDNTypeT, // 腾讯CDN
    XMDomainCDNTypeH, // 华为CDN
};

NS_ASSUME_NONNULL_BEGIN

@interface QYZYDomain : NSObject <NSSecureCoding>

/// 根据domain， CDNToken， CDNType， authType计算的唯一ID
@property (nonatomic, copy) NSString *domainID;
/// 域名
@property (nonatomic, copy) NSString *domain;

@property (nonatomic, copy) NSString *appstoreDomain;

/// 域名
@property (nonatomic, copy) NSString *host;

/// CDN token
@property (nonatomic, copy) NSString *CDNToken;

/// 最近一次检测耗时
@property (nonatomic, assign) NSUInteger timeConsume;

/// 域名权重
@property (nonatomic, assign) NSInteger weight;

/// 当前域名权重次数
@property (nonatomic, assign) NSInteger weightCnt;

/// CDN类型
@property (nonatomic, assign) XMDomainCDNType CDNType;

/// 是否开启CDN
@property (nonatomic, assign) BOOL openFlag;

/// 针对阿里CDN，腾讯CDN， 华为CDN 鉴权方式目前为A， B两种
@property (nonatomic, copy) NSString *authType;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)domainWithDomain:(NSString *)domain CDNType:(XMDomainCDNType)CDNType CDNToken:(NSString *)CDNToken authType:(NSString *)authType openFlag:(BOOL)openFlag weight:(NSInteger)weight;

+ (instancetype)domainWithEnCryptedDomain:(NSString *)domain enCryptedCDNType:(NSString *)CDNType CDNToken:(NSString *)CDNToken authType:(NSString *)authType openFlag:(BOOL)openFlag weight:(NSInteger)weight;

+ (instancetype)domainWithDomain:(NSString *)domain enCryptedCDNType:(NSString *)CDNType CDNToken:(NSString *)CDNToken authType:(NSString *)authType openFlag:(BOOL)openFlag weight:(NSInteger)weight;

+ (XMDomainCDNType)decrptedCDNType:(NSString *)type;

+ (NSString *)aci_decryptWithAES:(NSString *)string;

+ (NSString *)aci_encryptWithAES:(NSString *)string;

+ (NSData *)aci_decryptWithAESData:(NSData *)data;

+ (NSData *)aci_encryptWithAESData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
