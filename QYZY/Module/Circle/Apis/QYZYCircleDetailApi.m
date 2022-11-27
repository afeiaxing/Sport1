//
//  QYZYCircleDetailApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleDetailApi.h"

@implementation QYZYCircleDetailApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/post/reply/v2";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(self.pageNum) forKey:@"pageNum"];
    [params setValue:@(self.pageSize) forKey:@"pageSize"];
    [params setValue:self.postId forKey:@"postId"];
    [params setValue:@"desc" forKey:@"order"];
    [params setValue:@"created_date" forKey:@"orderField"];
    return params;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}



@end
