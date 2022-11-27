//
//  QYZYNewsDetailApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import "QYZYNewsDetailApi.h"

@implementation QYZYNewsDetailApi

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"/qiutx-news/app/news/%@",self.ID];
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{};
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
