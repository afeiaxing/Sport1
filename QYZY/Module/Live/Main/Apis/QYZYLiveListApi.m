//
//  QYZYLiveListApi.m
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import "QYZYLiveListApi.h"

@implementation QYZYLiveListApi

- (NSString *)requestUrl {
    if ([self.liveGroupId isEqualToString:@"14"]) {
        return @"/live-product/anonymous/v5/app/live/list/rookie";
    }
#if EnableRequestEncrpt
    return @"/live-product/anonymous/v6/app/live/listRobote";
#else
    return @"/live-product/anonymous/v6/app/live/list";
#endif
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.liveGroupId forKey:@"liveType"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
