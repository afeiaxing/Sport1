//
//  QYZYSettingPaswwordApi.m
//  QYZY
//
//  Created by jsmaster on 10/4/22.
//

#import "QYZYSettingPaswwordApi.h"

@implementation QYZYSettingPaswwordApi

- (NSString *)requestUrl {
    return @"/qiutx-usercenter/app/setpwd";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
        @"userName": self.userName,
        @"areaNo": @"86",
        @"passWord": self.passWord,
        @"ticket": self.ticket
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}


@end
