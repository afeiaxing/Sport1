//
//  QYZYSendSMSCodeApi.h
//  QYZY
//
//  Created by jsmaster on 10/3/22.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYSendSMSCodeApi : YTKRequest

@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *phone;

@end

NS_ASSUME_NONNULL_END
