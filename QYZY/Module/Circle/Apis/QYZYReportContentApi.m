//
//  QYZYReportContentApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import "QYZYReportContentApi.h"

@implementation QYZYReportContentApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/post/report/information";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *args = @{}.mutableCopy;
    return args;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
