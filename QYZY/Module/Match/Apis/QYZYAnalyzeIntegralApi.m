//
//  QYZYAnalyzeIntegralApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYAnalyzeIntegralApi.h"

@implementation QYZYAnalyzeIntegralApi
- (NSString *)requestUrl {
    if (self.isBasket) {
        return @"qiutx-score/v8/queryMatchLeagueRank/basketball";;
    }
    else {
        return @"qiutx-score/v8/queryMatchLeagueRank";
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.matchId ?: @"" forKey:@"matchId"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
