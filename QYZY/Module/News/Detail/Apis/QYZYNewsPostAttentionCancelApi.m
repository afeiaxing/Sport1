//
//  QYZYNewsPostAttentionCancelApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/3.
//

#import "QYZYNewsPostAttentionCancelApi.h"

@implementation QYZYNewsPostAttentionCancelApi

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"qiutx-news/app/post/attention/%@/cancel",self.userId];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{};
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
