//
//  QYZYRIMManager.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYRIMManager.h"
#import <YYCache/YYCache.h>

@interface QYZYRIMKeyApi : YTKRequest

@end

@implementation QYZYRIMKeyApi

- (NSString *)requestUrl {
    return @"/qiutx-support/get/sign/public/key";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{}.mutableCopy;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end

@interface QYZYRIMTokenApi : YTKRequest

@end

@implementation QYZYRIMTokenApi

- (NSString *)requestUrl {
    return @"/qiutx-usercenter/getRongCloud/token";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:QYZYUserManager.shareInstance.isLogin ? @1 : @0 forKey:@"isLogin"];
    if (QYZYUserManager.shareInstance.userModel.token) {
        [dict setValue:QYZYUserManager.shareInstance.userModel.uid forKey:@"userId"];
    }
    else {
        [dict setValue:[[UIDevice qyzy_getDeviceID] stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"userId"];
    }
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end

NSString * const QYZYRIMModelCacheKey = @"com.domain.RIM.cache";
@interface QYZYRIMManager ()
@property(nonatomic, strong) YYCache *cache;
@end

@implementation QYZYRIMManager

+ (instancetype)shareInstace {
    static dispatch_once_t onceToken;
    static QYZYRIMManager *shared;
    dispatch_once(&onceToken, ^{
        shared = [[QYZYRIMManager alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cache = [[YYCache alloc] initWithName:QYZYRIMModelCacheKey];
        self.rIMModel = (QYZYRIMModel *)[self.cache objectForKey:QYZYRIMModelCacheKey];
    }
    return self;
}

- (void)requestKeyData {
    QYZYRIMKeyApi *api = [[QYZYRIMKeyApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYRIMModel *rIMModel = [QYZYRIMModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        self.rIMModel = rIMModel;
        [self.cache setObject:rIMModel forKey:QYZYRIMModelCacheKey];
        [self registerRIM];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {}];
}

- (void)registerRIM {
    [RCIMClient.sharedRCIMClient initWithAppKey:self.appKey];
    [RCIMClient.sharedRCIMClient setReconnectKickEnable:NO];
    [self connectRIM];
}

- (void)connectRIM {
    QYZYRIMTokenApi *api = [[QYZYRIMTokenApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *token = request.responseJSONObject[@"data"];
        [self connectWithToken:token];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (void)connectWithToken:(NSString *)token {
    [RCIMClient.sharedRCIMClient connectWithToken:token dbOpened:^(RCDBErrorCode code) {
        
    } success:^(NSString * _Nonnull userId) {
        
    } error:^(RCConnectErrorCode errorCode) {
        
    }];
}

#pragma mark - get
- (NSString *)appKey {
    if (self.rIMModel && self.rIMModel.appId) {
        return self.rIMModel.appId;
    }
    else {
        return @"3argexb63p5xe";
    }
}

@end
