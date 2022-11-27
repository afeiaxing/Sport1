//
//  QYZYMyreservationApi.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYMyreservationApi.h"

@implementation QYZYMyreservationApi
- (NSString *)requestUrl {
    return @"/live-product/anonymous/v2/app/appointment/page";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSString *userid = [NSString stringWithFormat:@"%@",[QYZYUserManager shareInstance].userModel.uid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(200) forKey:@"pageSize"];
    [params setObject:@(1) forKey:@"pageNum"];
    [params setObject:userid forKey:@"userId"];
    
    return params.mutableCopy;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
