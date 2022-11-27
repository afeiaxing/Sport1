//
//  QYZYCircleHotListApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleHotListApi.h"

@implementation QYZYCircleHotListApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/post/index/list/v2";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.pageNum) forKey:@"pageNum"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    return params;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
