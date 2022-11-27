//
//  QYZYGetSetPasswordTicket.m
//  QYZY
//
//  Created by jsmaster on 10/14/22.
//

#import "QYZYGetSetPasswordTicketApi.h"

@implementation QYZYGetSetPasswordTicketApi

- (NSString *)requestUrl {
    return @"/qiutx-usercenter/app/setpwd/ticket";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeHTTP;
}

@end
