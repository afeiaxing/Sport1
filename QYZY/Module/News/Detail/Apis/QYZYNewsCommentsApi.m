//
//  QYZYNewsCommentsApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/3.
//

#import "QYZYNewsCommentsApi.h"

@implementation QYZYNewsCommentsApi

- (NSString *)requestUrl {
    return @"qiutx-news/app/news/comments";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
        @"pageNum": @(self.pageNum),
        @"pageSize": @(self.pageSize),
        @"orderField": @"time",
        @"newsId": self.newsId
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
