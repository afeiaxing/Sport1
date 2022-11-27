//
//  QYZYLiveRankDayApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYLiveRankDayApi.h"

@implementation QYZYLiveRankDayApi
- (NSString *)requestUrl {
    if (self.isDay) {
        return @"/live-product/anonymous/day/rank";
    }
    else {
        return @"/live-product/anonymous/week/rank";
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.anchorId forKey:@"anchorId"];
    if (QYZYUserManager.shareInstance.userModel) {
        [dict setValue:QYZYUserManager.shareInstance.userModel.uid forKey:@"currentUserId"];
    }
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
