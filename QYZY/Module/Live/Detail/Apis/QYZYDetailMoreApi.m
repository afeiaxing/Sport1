//
//  QYZYDetailMoreApi.m
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import "QYZYDetailMoreApi.h"

@implementation QYZYDetailMoreApi
- (NSString *)requestUrl {
    return @"/live-product/v2.0/live/recommend/list";
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
