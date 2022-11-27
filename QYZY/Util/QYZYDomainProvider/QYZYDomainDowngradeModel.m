//
//  XMDomainDowngradeModel.m
//  XMSport
//
//  Created by jsmaster on 8/20/22.
//  Copyright © 2022 XMSport. All rights reserved.
//

#import "QYZYDomainDowngradeModel.h"

@implementation QYZYDomainDowngradeModel

- (instancetype)initWithRank:(NSInteger)rank url:(NSString *)url type:(XMDomainDowngradeType)type {
    if (self = [super init]) {
        switch (type) {
            case XMDomainDowngradeTypeService:
                NSAssert(![[url lowercaseString] hasPrefix:@"http"], @"从服务端拉取域名时，只需配置接口路径!");
                break;
                
            default:
                NSAssert([[url lowercaseString] hasPrefix:@"http"], @"从OBS获取npm获取更多域名时， 需要配置完整URL!");
                break;
        }
        
        self.url = url;
        self.type = type;
        self.rank = rank;
    }
    return self;
}

- (NSString *)description {
    return [self yy_modelToJSONString];
}

@end
