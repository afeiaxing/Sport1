//
//  QYZYHotSearchApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "QYZYHotSearchApi.h"

@implementation QYZYHotSearchApi

- (NSString *)requestUrl {
    return @"/qiutx-score/v10/followTournament/hot";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{}.mutableCopy;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
