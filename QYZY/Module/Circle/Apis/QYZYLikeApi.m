//
//  QYZYLikeApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import "QYZYLikeApi.h"

@implementation QYZYLikeApi

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"/qiutx-news/app/post/like/%@",self.Id];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    return params;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
