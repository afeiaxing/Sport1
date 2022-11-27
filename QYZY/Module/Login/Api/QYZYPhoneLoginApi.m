//
//  QYZYPhoneLoginApi.m
//  QYZY
//
//  Created by jsmaster on 10/3/22.
//

#import "QYZYPhoneLoginApi.h"

@implementation QYZYPhoneLoginApi

- (NSString *)requestUrl {
    return @"/qiutx-passport/app/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"code": self.code,
        @"areaNo": @"86",
        @"userName": self.userName,
        @"inviteCode": @"",
        @"type": @"iOS"
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
