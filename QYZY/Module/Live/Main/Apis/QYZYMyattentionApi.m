//
//  QYZYMyattentionApi.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYMyattentionApi.h"

@implementation QYZYMyattentionApi

- (NSString *)requestUrl {
    return @"qiutx-news/app/post/space/focus/new";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSString *userid = [NSString stringWithFormat:@"%@",[QYZYUserManager shareInstance].userModel.uid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(200) forKey:@"pageSize"];
    [params setObject:@(1) forKey:@"pageNum"];
    [params setObject:userid forKey:@"focusUserId"];
    [params setObject:@"0" forKey:@"type"];
    
    return params.mutableCopy;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
