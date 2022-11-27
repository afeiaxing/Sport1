//
//  QYZYNewsFavoritesApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import "QYZYNewsFavoritesApi.h"

@implementation QYZYNewsFavoritesApi

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"qiutx-news/app/news/favorites/%@",self.ID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"id": self.ID,
    };
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
