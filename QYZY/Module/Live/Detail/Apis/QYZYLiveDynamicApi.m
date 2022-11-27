//
//  QYZYLiveDynamicApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/3.
//

#import "QYZYLiveDynamicApi.h"

@implementation QYZYLiveDynamicApi
- (NSString *)requestUrl {
    return @"/qiutx-news/app/post/anchor/applist";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.userId forKey:@"userId"];
    [dict setValue:@200 forKey:@"pageSize"];
    [dict setValue:@2 forKey:@"type"];
    [dict setValue:@"desc" forKey:@"order"];
    [dict setValue:@"created_date" forKey:@"orderField"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
