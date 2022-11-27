//
//  XMDomain.m
//  XMSport
//
//  Created by jsmaster on 8/20/22.
//  Copyright © 2022 XMSport. All rights reserved.
//

#import "QYZYDomain.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


NSInteger const XMDeaultDomainTimeConsume = 1000;
NSInteger const XMDeaultMaxDomainTimeConsume = 2000;
NSInteger const XMDeaultFailDomainTimeConsume = 5000;

NSString * const PSW_AES_KEY = @"8930ba380e7fdadf";
NSString * const AES_IV_PARAMETER = @"510cf0fcbdc4d20f";

@implementation QYZYDomain 

+ (instancetype)domainWithDomain:(NSString *)domain CDNType:(XMDomainCDNType)CDNType CDNToken:(NSString *)CDNToken authType:(NSString *)authType openFlag:(BOOL)openFlag weight:(NSInteger)weight {
    NSURL *url = [NSURL URLWithString:domain];
    NSAssert(url != nil && url.host != nil, @"传入的domain不合法！");
    
    QYZYDomain *domainModel = [QYZYDomain new];
    domainModel.domain = domain ?: @"";
    domainModel.host = url.host;
    domainModel.CDNType = CDNType;
    domainModel.CDNToken = CDNToken ?: @"";
    domainModel.authType = authType ?: @"";
    domainModel.openFlag = openFlag;
    domainModel.weight = weight;
    domainModel.timeConsume = XMDeaultDomainTimeConsume;
    
    //  不开启CDN鉴权默认走方能
    if (openFlag == false) {
        domainModel.CDNType = XMDomainCDNTypeFunnull;
    }
    
    domainModel.domainID = [[NSString stringWithFormat:@"%@-%ld-%@-%@", domainModel.domain, domainModel.CDNType, domainModel.CDNToken, domainModel.authType] qyzy_md5];
    
    return domainModel;
}

+ (instancetype)domainWithEnCryptedDomain:(NSString *)domain enCryptedCDNType:(NSString *)CDNType CDNToken:(NSString *)CDNToken authType:(NSString *)authType openFlag:(BOOL)openFlag weight:(NSInteger)weight {
    NSString *dom = domain;
    NSString *decryptDom = [self aci_decryptWithAES:domain];
    if (decryptDom.length != 0) {
        dom = decryptDom;
    }
    
    return [self domainWithDomain:dom enCryptedCDNType:CDNType CDNToken:CDNToken authType:authType openFlag:openFlag weight:weight];
}

+ (instancetype)domainWithDomain:(NSString *)domain enCryptedCDNType:(NSString *)CDNType CDNToken:(NSString *)CDNToken authType:(NSString *)authType openFlag:(BOOL)openFlag weight:(NSInteger)weight {
    XMDomainCDNType type = [self decrptedCDNType:CDNType];
    
    return [self domainWithDomain:domain CDNType:type CDNToken:CDNToken authType:authType openFlag:openFlag weight:weight];
}

- (BOOL)isEqual:(id)object {
    // 方能的域名， 域名相同， 对象即相等
    if ([object isKindOfClass:QYZYDomain.class] && [[(QYZYDomain *)object domain] isEqualToString:self.domain] && [(QYZYDomain *)object CDNType] == XMDomainCDNTypeFunnull && [self CDNType] == XMDomainCDNTypeFunnull) {
        return true;
    }
    
    // 因CDN配置切换问题， 域名相同， 不同的CDN配置，视为不同的域名
    if ([object isKindOfClass:QYZYDomain.class] && [[(QYZYDomain *)object domain] isEqualToString:self.domain] && [(QYZYDomain *)object CDNType] == self.CDNType && [[(QYZYDomain *)object CDNToken] isEqualToString:self.CDNToken] && [[(QYZYDomain *)object authType] isEqualToString:self.authType]) {
        return true;
    }
    
    return false;
}

- (NSString *)appstoreDomain {
    NSURL *url = [NSURL URLWithString:self.domain];
    if (url) {
        return [NSString stringWithFormat:@"%@://%@.%@", url.scheme, @"iosmanager", url.host];
    } else {
        return self.domain;
    }
}

+ (XMDomainCDNType)decrptedCDNType:(NSString *)type {
    if ([type isEqualToString:XMDomainCDNTypeAName]) {
        return XMDomainCDNTypeA;
    } else if ([type isEqualToString:XMDomainCDNTypeTName]) {
        return XMDomainCDNTypeT;
    } else if ([type isEqualToString:XMDomainCDNTypeHName]) {
        return XMDomainCDNTypeH;
    } else {
        return XMDomainCDNTypeFunnull;
    }
}

+ (NSString *)aci_decryptWithAES:(NSString *)string {
    NSData * baseData = [[NSData alloc]initWithBase64EncodedString:string options:0];
    NSData * AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    NSString * decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    return decStr;
}


+ (NSString *)aci_encryptWithAES:(NSString *)string {
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData * AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    /**< GTMBase64编码 */
    NSString * baseStr_GTM = [AESData base64EncodedStringWithOptions:0];
    return baseStr_GTM;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param data      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 *
 *  @return data
 */
+ (NSData *)AES128operation:(CCOperation)operation data:(NSData *)data key:(NSString *)key iv:(NSString *)iv {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    size_t bufferSize = [data length] + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptorStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                            keyPtr, kCCKeySizeAES128,
                                            ivPtr,
                                            [data bytes], [data length],
                                            buffer, bufferSize,
                                            &numBytesEncrypted);
    
    if(cryptorStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    } else {
        
    }
    
    free(buffer);
    return nil;
}

+ (NSData *)aci_decryptWithAESData:(NSData *)data {
    return [self AES128operation:kCCDecrypt
                            data:data
                             key:PSW_AES_KEY
                              iv:AES_IV_PARAMETER];
}

+ (NSData *)aci_encryptWithAESData:(NSData *)data {
    return [self AES128operation:kCCEncrypt
                            data:data
                             key:PSW_AES_KEY
                              iv:AES_IV_PARAMETER];
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.domainID forKey:@"domainID"];
    [coder encodeObject:self.domain forKey:@"domain"];
    [coder encodeObject:self.host forKey:@"host"];
    [coder encodeObject:self.CDNToken forKey:@"CDNToken"];
    [coder encodeObject:self.authType forKey:@"authType"];
    [coder encodeInteger:self.timeConsume forKey:@"timeConsume"];
    [coder encodeInteger:self.weight forKey:@"weight"];
    [coder encodeInteger:self.weightCnt forKey:@"weightCnt"];
    [coder encodeInteger:self.CDNType forKey:@"CDNType"];
    [coder encodeBool:self.openFlag forKey:@"openFlag"];
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if (self = [super init]) {
        self.domainID = [coder decodeObjectForKey:@"domainID"];
        self.domain = [coder decodeObjectForKey:@"domain"];
        self.host = [coder decodeObjectForKey:@"host"];
        self.CDNToken = [coder decodeObjectForKey:@"CDNToken"];
        self.authType = [coder decodeObjectForKey:@"authType"];
        self.timeConsume = [coder decodeIntegerForKey:@"timeConsume"];
        self.weight = [coder decodeIntegerForKey:@"weight"];
        self.weightCnt = [coder decodeIntegerForKey:@"weightCnt"];
        self.CDNType = [coder decodeIntegerForKey:@"CDNType"];
        self.openFlag = [coder decodeBoolForKey:@"openFlag"];
    }
    return self;
}

- (NSString *)description {
    return [self yy_modelToJSONString];
}

@end
