//
//  QYZYTotalNewsApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import "QYZYTotalNewsApi.h"

@implementation QYZYTotalNewsApi

- (NSString *)requestUrl {
    return @"qiutx-news/app/news/page";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
        @"pageNum": @(self.pageNum),
        @"pageSize": @(self.pageSize),
        @"mediaType":@(self.mediaType),
        @"categoryId":self.categoryId,
        @"sportType":self.sportType
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
