//
//  QYZYLiveMainHotApi.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveMainHotApi.h"

@implementation QYZYLiveMainHotApi

- (NSString *)requestUrl {
    return @"/live-product/anonymous/appstore/popular/anchors";
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
