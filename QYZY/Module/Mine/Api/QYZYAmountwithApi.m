//
//  QYZYAmountwithApi.m
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import "QYZYAmountwithApi.h"

@implementation QYZYAmountwithApi

- (NSString *)requestUrl {
    
    return @"qiutx-integral/app/wallet/currentAmount";
    
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
