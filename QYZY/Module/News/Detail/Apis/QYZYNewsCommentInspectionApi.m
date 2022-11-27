//
//  QYZYNewsCommentInspectionApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/3.
//

#import "QYZYNewsCommentInspectionApi.h"

@implementation QYZYNewsCommentInspectionApi

- (NSString *)requestUrl {
    return @"qiutx-news/app/prophecy/inspection/comment";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
         @"nickname" : !QYZYUserManager.shareInstance.isLogin ? @"" : QYZYUserManager.shareInstance.userModel.nickName,
         @"text" : self.text,
         @"code": @"headline_comment"
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
