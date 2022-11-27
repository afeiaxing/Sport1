//
//  QYZYFootballApi.m
//  QYZY
//
//  Created by jspatches on 2022/9/30.
//

#import "QYZYFootballApi.h"

@implementation QYZYFootballApi

- (NSString *)requestUrl {
    
    return @"/live-product/anonymous/v1/find/match/pool";
    
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    
    NSString *uid = [NSString stringWithFormat:@"%@",[QYZYUserManager shareInstance].userModel.uid];
    if (!uid.length) {
        uid = [UIDevice qyzy_getDeviceID];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [params setValue:uid forKey:@"userId"];
    [params setValue:@(30) forKey:@"limit"];
    return params.mutableCopy;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}



@end
