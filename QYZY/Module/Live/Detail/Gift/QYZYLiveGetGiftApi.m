//
//  QYZYLiveGetGiftApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "QYZYLiveGetGiftApi.h"

@implementation QYZYLiveGetGiftApi
- (NSString *)requestUrl {
    return @"/live-product/v1/gift/getGiftList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
