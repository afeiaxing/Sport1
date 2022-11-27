//
//  QYZYBasketBallPointApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYBasketBallPointApi.h"

@implementation QYZYBasketBallPointApi

- (NSString *)requestUrl {
    return @"/qiutx-score/v6/match/contrast/basketball";
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
