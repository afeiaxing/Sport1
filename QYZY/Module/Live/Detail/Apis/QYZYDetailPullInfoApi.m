//
//  QYZYDetailPullInfoApi.m
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import "QYZYDetailPullInfoApi.h"
#import "QYZYAppConfig.h"

@implementation QYZYDetailPullInfoApi
- (NSString *)requestUrl {
#if EnableRequestEncrpt
    return @"/live-product/anonymous/v1/room/pull/animinfo";
#else
    return @"/live-product/anonymous/v1/room/pull/info";
#endif
    
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
