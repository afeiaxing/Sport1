//
//  QYZYAnalyzeRecentApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/14.
//

#import "QYZYAnalyzeRecentApi.h"

@implementation QYZYAnalyzeRecentApi

- (NSString *)requestUrl {
    if (self.isBasket) {
        return @"/qiutx-score/v4/team/recentRecords/basketball";
    }
    else {
        return @"/qiutx-score/v4/team/recentRecords";
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.matchId ?: @"" forKey:@"matchId"];
    [dict setValue:self.teamId ?: @"" forKey:@"teamId"];
    [dict setValue:self.side ?: @"all" forKey:@"side"];
    [dict setValue:self.leagueId ?: @"" forKey:@"leagueId"];
    [dict setValue:@20 forKey:@"size"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
