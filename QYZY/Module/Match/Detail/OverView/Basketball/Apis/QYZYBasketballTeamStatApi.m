//
//  QYZYBasketballTeamStatApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYBasketballTeamStatApi.h"

@implementation QYZYBasketballTeamStatApi

- (NSString *)requestUrl {
    return @"/qiutx-score/v7/queryBasketballTeamStat";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.matchId forKey:@"matchId"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
