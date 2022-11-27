//
//  QYZYAnalyzeHistoryApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/14.
//

#import "QYZYAnalyzeHistoryApi.h"

@implementation QYZYAnalyzeHistoryApi

- (NSString *)requestUrl {
    return @"/qiutx-score/v4/team/hostAndGuest";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.matchId ?: @"" forKey:@"matchId"];
    [dict setValue:self.hostTeamId ?: @"" forKey:@"hostTeamId"];
    [dict setValue:self.guestTeamId ?: @"" forKey:@"guestTeamId"];
    if (self.isSameLeague) {
        [dict setValue:self.leagueId ?: @"" forKey:@"leagueId"];
    }
    [dict setValue:[NSNumber numberWithBool:self.isSameHostGuest] ?: @"" forKey:@"fixed"];
    [dict setValue:@20 forKey:@"size"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
