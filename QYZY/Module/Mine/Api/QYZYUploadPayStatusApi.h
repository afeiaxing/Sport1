//
//  QYZYUploadPayStatusApi.h
//  QYZY
//
//  Created by jsmaster on 10/15/22.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYUploadPayStatusApi : YTKRequest

@property(nonatomic, copy) NSString *payOrderId;
@property(nonatomic, copy) NSString *goodsId;
@property(nonatomic, copy) NSString *payload;
@property(nonatomic, copy) NSString *transactionId;

@end

NS_ASSUME_NONNULL_END
