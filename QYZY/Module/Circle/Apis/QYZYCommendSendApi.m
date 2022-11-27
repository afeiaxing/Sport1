//
//  QYZYCommendSendApi.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import "QYZYCommendSendApi.h"

@implementation QYZYCommendSendApi

- (NSString *)requestUrl {
    return @"/qiutx-news/app/post/posting";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:self.content forKey:@"content"];
    [params setValue:self.replyId forKey:@"replyId"];
    [params setValue:self.isComment forKey:@"isComment"];
    return params;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}


@end
