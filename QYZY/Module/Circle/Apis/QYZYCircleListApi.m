//
//  QYZYCircleListApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleListApi.h"

@implementation QYZYCircleListApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/get/circle";
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
