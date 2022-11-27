//
//  QYZYPullDomainsApi.m
//  QYZY
//
//  Created by jsmaster on 10/11/22.
//

#import "QYZYPullDomainsApi.h"

@implementation QYZYPullDomainsApi

- (NSString *)requestUrl {
    return self.fullURL;
}

- (id)requestArgument {
    return @{@"timestamp": @([[NSDate date] timeIntervalSince1970])};
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
