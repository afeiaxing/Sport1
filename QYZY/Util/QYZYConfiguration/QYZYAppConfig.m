//
//  QYZYAppConfig.m
//  QYZY
//
//  Created by jsmaster on 9/29/22.
//

#import "QYZYAppConfig.h"
#import "QYZYCustomRequestFilter.h"
#import "QYZYDomainProvider.h"
#import "IQKeyboardManager.h"
#import "QYZYBlockManager.h"
#import "QYZYRIMManager.h"
#import "JPUSHService.h"
#import <UMCommon/UMCommon.h>

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface QYZYAppConfig () <JPUSHRegisterDelegate>

@end

@implementation QYZYAppConfig


+ (void)configWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configNetwork];
    [self configRongIM];
    [self configKeyboard];
    [self configUmeng];
    [self configUserResource];
    [self configJiGugangWithapplication:application didFinishLaunchingWithOptions:launchOptions];
    
}

#pragma mark - network
+ (void)configNetwork {
    [QYZYDomainProvider.shareInstance addDomains:[self getLocalDomains]];
    [QYZYDomainProvider.shareInstance addDomainDowngradeModels:@[
        [[QYZYDomainDowngradeModel alloc] initWithRank:0    url:@"/qiutx-support/domains/v2/pull" type:XMDomainDowngradeTypeService],
        [[QYZYDomainDowngradeModel alloc] initWithRank:100  url:[self getHuaweiCloudDoaminURL] type:XMDomainDowngradeTypeOBS],
        [[QYZYDomainDowngradeModel alloc] initWithRank:200  url:[self getUnpkgDoaminURL] type:XMDomainDowngradeTypeOBS],
        [[QYZYDomainDowngradeModel alloc] initWithRank:1000 url:[self getCNpmDoaminURL] type:XMDomainDowngradeTypeNpm],
        [[QYZYDomainDowngradeModel alloc] initWithRank:2000 url:[self getTaobaoNpmDoaminURL] type:XMDomainDowngradeTypeNpm],
        [[QYZYDomainDowngradeModel alloc] initWithRank:3000 url:[self getTencentNpmDoaminURL] type:XMDomainDowngradeTypeNpm],
        [[QYZYDomainDowngradeModel alloc] initWithRank:4000 url:[self getYarnNpmDoaminURL] type:XMDomainDowngradeTypeNpm]
    ]];
    [QYZYDomainProvider.shareInstance checkDomains];
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = [QYZYDomainProvider.shareInstance getDomainInstantlyForWeight:false].domain; //@"https://ios.qiu994.com";
    QYZYCustomRequestFilter *filter = [QYZYCustomRequestFilter new];
    [config addUrlFilter:filter];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if ((status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:QYZYNetworkingFirstAvaliableNotification object:nil];
        }
    
    }];
}

+ (NSArray <QYZYDomain *> *)getLocalDomains {
#if EnableRequestEncrpt
    return @[
        // https://tlsapi.qiu994.com
        [QYZYDomain domainWithEnCryptedDomain:@"pW+fvLdTRkR6+/oY+5i9Id2KcdeK1ImNhbkAeiZI+dA=" enCryptedCDNType:XMDomainCDNTypeFName CDNToken:@"eba9b9516a601422b1c20e093f52f9a9" authType:@"" openFlag:true weight:40]
    ];
#else
    return @[
        // https://api.dq87774.com
        [QYZYDomain domainWithEnCryptedDomain:@"dsWZu9x7TALaTWz0zgz8m6ceP27PTE1j5jai0Bk/u3s=" enCryptedCDNType:XMDomainCDNTypeFName CDNToken:@"eba9b9516a601422b1c20e093f52f9a9" authType:@"" openFlag:true weight:40],
        // https://api.k396w.com
        [QYZYDomain domainWithEnCryptedDomain:@"+7cKHXQY4EbT8/kvI3JWuXEzFmgzm8O74zK/XS/xI50=" enCryptedCDNType:XMDomainCDNTypeAName CDNToken:@"JmQ8uEKn6g96nSsWccw" authType:@"A" openFlag:true weight:7],
        // https://api-al.k396w.com
        [QYZYDomain domainWithEnCryptedDomain:@"+PZGz+2TPCk0m0SgZfjCC6sOT4HtH9SLr80GBzW1OC4=" enCryptedCDNType:XMDomainCDNTypeAName CDNToken:@"JmQ8uEKn6g96nSsWccw" authType:@"A" openFlag:true weight:7],
        // https://api.kjwinm.cn
        [QYZYDomain domainWithEnCryptedDomain:@"zGj6sIyYe8ol/oGq4kImoAv8Vg0cXE/PaqZJNu2tRf0=" enCryptedCDNType:XMDomainCDNTypeHName CDNToken:@"JmQ8uEKn6g96nSsWccw" authType:@"A" openFlag:true weight:6],
        // https://api-al.hzmgrn.com
        [QYZYDomain domainWithEnCryptedDomain:@"mthxGFbN8Wopxp6cQbHLoeAmEwmAUFaoHe2hnk5STbM=" enCryptedCDNType:XMDomainCDNTypeAName CDNToken:@"JmQ8uEKn6g96nSsWccw" authType:@"A" openFlag:true weight:40]
    ];
#endif

}

+ (NSString *)getHuaweiCloudDoaminURL {
#if EnableRequestEncrpt
    return @"https://bfw-pic-new.obs.cn-south-1.myhuaweicloud.com/cdn/appstore_prod.json";
#else
    return @"https://bfw-pic-new.obs.cn-south-1.myhuaweicloud.com/cdn/app_prod.json";
#endif
    
}

+ (NSString *)getUnpkgDoaminURL {
#if EnableRequestEncrpt
    return @"https://unpkg.com/@yuming2022/appstore-dnpkg-prod";
#else
    return @"https://unpkg.com/@yuming2022/app-dnpkg-prod";
#endif
    
}

+ (NSString *)getCNpmDoaminURL {
#if EnableRequestEncrpt
    return @"https://r.cnpmjs.org/@yuming2022/appstore-dnpkg-prod";
#else
    return @"https://r.cnpmjs.org/@yuming2022/app-dnpkg-prod";
#endif
    
}

+ (NSString *)getTaobaoNpmDoaminURL {
#if EnableRequestEncrpt
    return @"https://registry.npmmirror.com/@yuming2022/appstore-dnpkg-prod";
#else
    return @"https://registry.npmmirror.com/@yuming2022/app-dnpkg-prod";
#endif
    
}

+ (NSString *)getTencentNpmDoaminURL {
#if EnableRequestEncrpt
    return @"https://mirrors.cloud.tencent.com/npm/@yuming2022/appstore-dnpkg-prod";
#else
    return @"https://mirrors.cloud.tencent.com/npm/@yuming2022/app-dnpkg-prod";
#endif
    
}

+ (NSString *)getYarnNpmDoaminURL {
#if EnableRequestEncrpt
    return @"https://registry.yarnpkg.com/@yuming2022/appstore-dnpkg-prod";
#else
    return @"https://registry.yarnpkg.com/@yuming2022/app-dnpkg-prod";
#endif
    
}

#pragma mark - RongIM
+ (void)configRongIM {
    [QYZYRIMManager.shareInstace requestKeyData];
}

#pragma mark - Keyboard
+ (void)configKeyboard {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

#pragma mark - JiGugang
+ (void)configJiGugangWithapplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    
    if (@available(iOS 12.0, *)) {
       entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
     } else {
       entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
     }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    NSString *appKey  = @"09986335d73a3d8569c0023b";
    NSString *channel = nil;
    BOOL isProduction = NO;
#ifdef DEBUG
    channel = nil;
    isProduction = NO;
#else
    channel = @"App Store";
    isProduction = YES;
#endif
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
      
    }];
    
    [JPUSHService setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
+ (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler(0 /*UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert*/); //
}

// iOS 10 Support
+ (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    
}



#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification  API_AVAILABLE(ios(10.0)){
    
}
#endif

#pragma mark - Umeng
+ (void)configUmeng {
    [UMConfigure initWithAppkey:@"5e43ceaacb23d2efa7000076" channel:@"Apple Store"];
}
    
#pragma mark - user resource
+ (void)configUserResource {
    [QYZYBlockManager.shareInstance requestData];
}


@end
