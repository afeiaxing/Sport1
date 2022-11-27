//
//  QYZYUserManager.m
//  QYZY
//
//  Created by jsmaster on 9/30/22.
//

#import "QYZYUserManager.h"
#import <YYCache/YYCache.h>


NSString * const QYZYUserModelCacheKey = @"com.domain.user.cache";
NSString * const QYZYMineModelCacheKey = @"com.domain.mine.cache";

@interface QYZYUserManager  ()

@property(nonatomic, strong) YYCache *cache;

@end

@implementation QYZYUserManager

+ (instancetype)shareInstance {
    static QYZYUserManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cache = [[YYCache alloc] initWithName:@"com.domain.user.cache"];
        self.userModel = (QYZYUserModel *)[self.cache objectForKey:QYZYUserModelCacheKey];
        self.mineModel = (QYZYMineModel *)[self.cache objectForKey:QYZYMineModelCacheKey];
    }
    return self;
}

- (BOOL)isLogin {
    return self.userModel != nil;
}

- (void)saveUserModel:(QYZYUserModel <NSCoding> *)model {
    self.userModel = model;
    [self.cache setObject:model forKey:QYZYUserModelCacheKey];
}

- (void)saveMineModel:(QYZYMineModel <NSCoding> * __nullable)model {
    self.mineModel = model;
    [self.cache setObject:model forKey:QYZYMineModelCacheKey];
}

@end
