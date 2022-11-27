//
//  QYZYHotNewsApi.m
//  QYZY
//
//  Created by jsmaster on 10/1/22.
//

#import "QYZYHotNewsApi.h"

@implementation QYZYHotNewsApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/index";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
        @"pageNum": @(self.pageNum),
        @"pageSize": @(self.pageSize)
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
