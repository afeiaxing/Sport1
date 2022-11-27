//
//  QYZYPlayersApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYPlayersApi.h"

@implementation QYZYPlayersApi

- (NSString *)requestUrl {
    return @"/qiutx-score/v9/info/match/player/stat/detail";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.matchId forKey:@"matchId"];
    [dict setValue:@(YES) forKey:@"aggr"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
