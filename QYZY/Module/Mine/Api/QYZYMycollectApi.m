//
//  QYZYMycollectApi.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYMycollectApi.h"

@implementation QYZYMycollectApi

- (NSString *)requestUrl {
    return @"qiutx-news/app/favorites";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
 
    return @{
        @"pageNum": @(self.pageNum),
        @"pageSize": @(self.pageSize)};
    
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}


@end
