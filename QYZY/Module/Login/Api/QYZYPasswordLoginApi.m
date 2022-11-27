//
//  QYZYLoginApi.m
//  QYZY
//
//  Created by jsmaster on 9/29/22.
//

#import "QYZYPasswordLoginApi.h"

@interface QYZYPasswordLoginApi ()

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *password;

@end

@implementation QYZYPasswordLoginApi

+ (instancetype)passwordLoginApiWithUserName:(NSString *)userName password:(NSString *)password {
    QYZYPasswordLoginApi *api = [QYZYPasswordLoginApi new];
    api.userName = userName;
    api.password = password;
    return api;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl {
    return @"/qiutx-passport/app/login";
}

- (id)requestArgument {
    return @{
        @"userName": self.userName,
        @"type": @"iOS",
        @"areaNo": @"86",
        @"passWord": self.password
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
