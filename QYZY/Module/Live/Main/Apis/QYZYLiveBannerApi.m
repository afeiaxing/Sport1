//
//  QYZYLiveBannerApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "QYZYLiveBannerApi.h"

@implementation QYZYLiveBannerApi
- (NSString *)requestUrl {

    return @"/qiutx-news/banner/find/position";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:@"APP/H5" forKey:@"client"];
    [dict setValue:@"1" forKey:@"position"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
