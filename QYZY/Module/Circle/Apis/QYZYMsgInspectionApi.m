//
//  QYZYMsgInspectionApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import "QYZYMsgInspectionApi.h"

@implementation QYZYMsgInspectionApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/prophecy/inspection";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSString *text = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:text forKey:@"text"];
    return params;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
