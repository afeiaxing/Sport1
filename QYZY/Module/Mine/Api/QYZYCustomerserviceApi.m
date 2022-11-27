//
//  QYZYCustomerserviceApi.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYCustomerserviceApi.h"

@implementation QYZYCustomerserviceApi

- (NSString *)requestUrl {
    
    return @"qiutx-support/get/echat/url";
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
