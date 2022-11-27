//
//  QYZYPhoneLoginApi.h
//  QYZY
//
//  Created by jsmaster on 10/3/22.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYPhoneLoginApi : YTKRequest

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *code;

@end

NS_ASSUME_NONNULL_END
