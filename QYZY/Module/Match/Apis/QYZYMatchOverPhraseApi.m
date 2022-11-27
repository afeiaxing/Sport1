//
//  QYZYMatchOverPhraseApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYMatchOverPhraseApi.h"

@implementation QYZYMatchOverPhraseApi

- (NSString *)requestUrl {
    return @"/qiutx-score/v8/queryMatchPhrase";
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
