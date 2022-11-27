//
//  QYZYNewsPostAttentionApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/3.
//

#import "QYZYNewsPostAttentionApi.h"

@implementation QYZYNewsPostAttentionApi

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"qiutx-news/app/post/attention/%@",self.userId];
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
