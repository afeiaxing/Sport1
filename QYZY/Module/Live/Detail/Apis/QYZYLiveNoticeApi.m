//
//  QYZYLiveNoticeApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/4.
//

#import "QYZYLiveNoticeApi.h"

@implementation QYZYLiveNoticeApi
- (NSString *)requestUrl {
    return @"/live-product/v1/anchor/order/list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.anchorId forKey:@"anchorId"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
