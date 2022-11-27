//
//  QYZYBlockManager.m
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import "QYZYBlockManager.h"
#import <YYCache/YYCache.h>

@interface QYZYBlockApi : YTKRequest

@end

@implementation QYZYBlockApi

- (NSString *)requestUrl {
    return @"/qiutx-usercenter/user/resources";
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

NSString * const QYZYBlockModelCacheKey = @"com.domain.block.cache";

@interface QYZYBlockManager ()
@property(nonatomic, strong) YYCache *cache;
@end

@implementation QYZYBlockManager

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static QYZYBlockManager *shared;
    dispatch_once(&onceToken, ^{
        shared = [[QYZYBlockManager alloc] init];
    });
    return shared;
}

+ (BOOL)isBlockedByLeagueId:(NSString *)leagueId {
    return QYZYBlockManager.shareInstance.blockModel.blockingByDeviceId ||
    QYZYBlockManager.shareInstance.blockModel.blockingByIp ||
                [QYZYBlockManager.shareInstance.blockModel.blockingLeagueIds containsObject:@(leagueId.integerValue)];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cache = [[YYCache alloc] initWithName:QYZYBlockModelCacheKey];
        self.blockModel = (QYZYBlockModel *)[self.cache objectForKey:QYZYBlockModelCacheKey];
    }
    return self;
}

- (void)requestData {
    QYZYBlockApi *api = [[QYZYBlockApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYBlockModel *model = [QYZYBlockModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        self.blockModel = model;
        [self.cache setObject:model forKey:QYZYBlockModelCacheKey];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

@end
