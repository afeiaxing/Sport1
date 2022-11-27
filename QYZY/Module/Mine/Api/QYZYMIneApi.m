//
//  QYZYMIneApi.m
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import "QYZYMIneApi.h"

@implementation QYZYMIneApi

- (NSString *)requestUrl {
    
    NSString *url =  [NSString stringWithFormat:@"qiutx-news/app/post/author/space/%@",self.uid];
    return url;
    
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
