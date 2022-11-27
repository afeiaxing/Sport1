//
//  QYZYRankApi.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYRankApi.h"

@implementation QYZYRankApi


- (NSString *)requestUrl {
    if (self.isDay) {
        //人气主播榜
        return @"live-product/anonymous/v1/rank/anchor/list";
    }
    else {
        //达人豪气榜
        return @"live-product/anonymous/v1/price/rank/anchor/list";
    }
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.type forKey:@"rankType"];
    if (QYZYUserManager.shareInstance.userModel) {
        [dict setValue:QYZYUserManager.shareInstance.userModel.uid forKey:@"currentUserId"];
    }
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
