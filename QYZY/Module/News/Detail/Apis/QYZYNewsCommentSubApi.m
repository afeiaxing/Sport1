//
//  QYZYNewsCommentSubApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import "QYZYNewsCommentSubApi.h"

@implementation QYZYNewsCommentSubApi

- (NSString *)requestUrl {
    return @"qiutx-news/app/news/soncomments";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
        @"pageNum": @(self.pageNum),
        @"pageSize": @(self.pageSize),
        @"orderField": @"time",
        @"commentId": self.commentId
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
