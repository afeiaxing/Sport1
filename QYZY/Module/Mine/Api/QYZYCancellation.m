//
//  QYZYCancellation.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYCancellation.h"

@implementation QYZYCancellation

- (NSString *)requestUrl {
    return @"qiutx-usercenter/log/off/user";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
 
    return @{
        @"code":self.code,
        @"type": @"6"};
    
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
