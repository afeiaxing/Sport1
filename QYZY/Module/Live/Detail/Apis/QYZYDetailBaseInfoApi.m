//
//  QYZYDetailBaseInfoApi.m
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import "QYZYDetailBaseInfoApi.h"

@implementation QYZYDetailBaseInfoApi
- (NSString *)requestUrl {
    return @"/live-product/anonymous/v1/room/basic/info";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.anchorId forKey:@"anchorId"];
    [dict setValue:QYZYUserManager.shareInstance.userModel.uid forKey:@"currentUserId"];
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
