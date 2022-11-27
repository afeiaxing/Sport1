//
//  QYZYCircleFollowApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleFollowApi.h"

@implementation QYZYCircleFollowApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/post/getFollowContent";
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
