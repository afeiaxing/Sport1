//
//  QYZYCircleAllList.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleAllListApi.h"

@implementation QYZYCircleAllListApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/circle/post/list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.pageNum) forKey:@"pageNum"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:self.sort forKey:@"sort"];
    [params setValue:self.circleId forKey:@"circleId"];
    [params setValue:self.recommendStatus forKey:@"recommendStatus"];
    return params;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}


@end
