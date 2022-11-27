//
//  QYZYCancelCollectApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import "QYZYCancelCollectApi.h"

@implementation QYZYCancelCollectApi

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"/qiutx-news/app/post/favorites/removeConcerns/%@",self.Id];
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
