//
//  QYZYLiveMainGroupApi.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveMainGroupApi.h"

@implementation QYZYLiveMainGroupApi

- (NSString *)requestUrl {
    return @"/live-product/anonymous/v1/anchor/all/type/list";
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
