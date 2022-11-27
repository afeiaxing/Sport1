//
//  QYZYCreateRechargeOrderApi.m
//  QYZY
//
//  Created by jsmaster on 10/14/22.
//

#import "QYZYCreateRechargeOrderApi.h"

@implementation QYZYCreateRechargeOrderApi

- (NSString *)requestUrl {
    
    return @"/qiutx-pay/api/pay/recharge";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"amount": self.amount,
        @"channelId": @"IAP",
        @"body": @"购买财富豆",
        @"subject": @"购买财富豆",
        @"currency": @"cny"};
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
