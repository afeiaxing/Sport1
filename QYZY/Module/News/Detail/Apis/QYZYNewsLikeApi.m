//
//  QYZYNewsLikeApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import "QYZYNewsLikeApi.h"

@implementation QYZYNewsLikeApi

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"qiutx-news/app/news/like/%@",self.ID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{};
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
