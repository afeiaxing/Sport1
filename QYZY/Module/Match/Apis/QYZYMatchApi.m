//
//  QYZYMatchApi.m
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import "QYZYMatchApi.h"

@implementation QYZYMatchApi
- (NSString *)requestUrl {
    return @"/qiutx-score/v10/queryAllByStatus";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:@(self.matchType) forKey:@"sportType"];
    [dict setValue:self.currentDateString forKey:@"date"];
    [dict setValue:@"" forKey:@"status"];
    [dict setValue:@1 forKey:@"isComplete"];
    [dict setValue:@0 forKey:@"isAll"];
    [dict setValue:@0 forKey:@"isFormated"];
    if (QYZYUserManager.shareInstance.isLogin) {
        [dict setValue:QYZYUserManager.shareInstance.userModel.uid forKey:@"userId"];
    } else {
        [dict setValue:[UIDevice qyzy_getDeviceID] forKey:@"userId"];
    }
    return dict;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}
@end
