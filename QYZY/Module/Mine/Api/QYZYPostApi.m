//
//  QYZYPostApi.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYPostApi.h"

@implementation QYZYPostApi

- (NSString *)requestUrl {
    return @"qiutx-news/app/post/space/list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    return @{
        @"authorId":self.authorId,
        @"pageNum": @(self.pageNum),
        @"pageSize": @(self.pageSize)
    };
    
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
