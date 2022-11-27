//
//  QYZYLiveChatFilterApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "QYZYLiveChatFilterApi.h"

@implementation QYZYLiveChatFilterApi
- (NSString *)requestUrl {
    return @"/qiutx-news/app/chat/commonFilter";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.content forKey:@"content"];
    [dict setValue:@"LIVE_CHAT_ROOM" forKey:@"enumItem"];
    [dict setValue:QYZYUserManager.shareInstance.userModel.uid forKey:@"userId"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
