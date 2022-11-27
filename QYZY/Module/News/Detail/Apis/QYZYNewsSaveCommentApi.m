//
//  QYZYNewsSaveCommentApi.m
//  QYZY
//
//  Created by jsgordong on 2022/10/3.
//

#import "QYZYNewsSaveCommentApi.h"

@implementation QYZYNewsSaveCommentApi

- (NSString *)requestUrl {
    return @"qiutx-news/app/news/savecomment";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    if (self.replyId) {
        return @{
             @"newsId" : self.newsId,
             @"content" : self.content,
             @"replyId": self.replyId
        };
    }else {
        return @{
             @"newsId" : self.newsId,
             @"content" : self.content,
             @"isMoreReply": @0
        };
    }
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
