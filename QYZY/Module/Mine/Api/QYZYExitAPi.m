//
//  QYZYExitAPi.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYExitAPi.h"

@implementation QYZYExitAPi
- (NSString *)requestUrl {
    
    return @"qiutx-passport/auth/logout";
    
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSString *userId = [NSString stringWithFormat:@"%@",[QYZYUserManager shareInstance].userModel.uid];
    return @{@"userId":userId}.mutableCopy;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
