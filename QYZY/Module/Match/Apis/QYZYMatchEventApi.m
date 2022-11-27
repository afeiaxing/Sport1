//
//  QYZYMatchEventApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/23.
//

#import "QYZYMatchEventApi.h"

@implementation QYZYMatchEventApi

- (NSString *)requestUrl {
    return @"/qiutx-score/soccer/match/events";
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
