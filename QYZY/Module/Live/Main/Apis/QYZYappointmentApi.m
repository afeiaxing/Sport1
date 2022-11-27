//
//  QYZYappointmentApi.m
//  QYZY
//
//  Created by jspatches on 2022/9/30.
//

#import "QYZYappointmentApi.h"

@implementation QYZYappointmentApi
- (NSString *)requestUrl {
    if (self.isBook) {
        return @"qiutx-score/anonymous/v1/app/appointment/add";
    } else {
        return @"qiutx-score/anonymous/v1/app/appointment/cancel";
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSString *userid = [NSString stringWithFormat:@"%@",[QYZYUserManager shareInstance].userModel.uid];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.leagueId forKey:@"matchId"];
    [params setObject:userid forKey:@"userId"];
    return params.mutableCopy;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
