//
//  QYZYSearchApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "QYZYSearchApi.h"

@implementation QYZYSearchApi

- (NSString *)requestUrl {
    return @"/live-product/anonymous/v1/search";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.keyword forKey:@"keyword"];
    [params setValue:@(self.searchType) forKey:@"searchType"];
    return params;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
