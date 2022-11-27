//
//  QYZYSendSMSCodeApi.m
//  QYZY
//
//  Created by jsmaster on 10/3/22.
//

#import "QYZYSendSMSCodeApi.h"

@implementation QYZYSendSMSCodeApi

- (NSString *)requestUrl {
    return @"/qiutx-sms/sms/send/code";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"type": self.type,
        @"areaNo": @"86",
        @"phone": self.phone,
        @"disabledGeeTest": @1
    };
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary {
    return @{@"client-tag": @"dq13"};
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
