//
//  QYZYMatchDetailApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYMatchDetailApi.h"

@implementation QYZYMatchDetailApi

- (NSString *)requestUrl {
    return @"/qiutx-score/v5/match/match";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.matchId forKey:@"id"];
    if (QYZYUserManager.shareInstance.isLogin) {
        [dict setValue:QYZYUserManager.shareInstance.userModel.uid forKey:@"userId"];
    }
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
