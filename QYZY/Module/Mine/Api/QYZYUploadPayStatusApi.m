//
//  QYZYUploadPayStatusApi.m
//  QYZY
//
//  Created by jsmaster on 10/15/22.
//

#import "QYZYUploadPayStatusApi.h"

@implementation QYZYUploadPayStatusApi

- (NSString *)requestUrl {
    
    return @"/qiutx-pay/api/pay/iosVerify";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
        @"payOrderId": self.payOrderId,
        @"goodsId": self.goodsId,
        @"payload": self.payload,
        @"transactionId": self.transactionId};
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

@end
