//
//  QYZYMatchApi.h
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchApi : YTKRequest
@property (nonatomic, strong) NSString *currentDateString;
@property (nonatomic ,assign) QYZYMatchType matchType;
@end

NS_ASSUME_NONNULL_END
