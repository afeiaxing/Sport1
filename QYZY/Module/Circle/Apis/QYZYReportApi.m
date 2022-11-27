//
//  QYZYReportApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import "QYZYReportApi.h"

@implementation QYZYReportApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/post/report";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *args = @{}.mutableCopy;
    [args setValue:self.idType forKey:@"idType"];
    [args setValue:self.reason forKey:@"reason"];
    [args setValue:self.reasonId forKey:@"reasonId"];
    [args setValue:self.reportBy forKey:@"reportBy"];
    return args;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}


@end
