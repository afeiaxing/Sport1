//
//  QYZYFutureRecordsApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/25.
//

#import "QYZYFutureRecordsApi.h"

@implementation QYZYFutureRecordsApi
- (NSString *)requestUrl {
    return @"qiutx-score/v4/team/uncoming3";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.matchId ?: @"" forKey:@"matchId"];
    [dict setValue:self.teamId ?: @"" forKey:@"teamId"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
