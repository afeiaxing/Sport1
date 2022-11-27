//
//  QYZYFutureRecordsApi.h
//  QYZY
//
//  Created by jspollo on 2022/10/25.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYFutureRecordsApi : YTKRequest
@property (nonatomic, strong) NSString *matchId;
@property (nonatomic, strong) NSString *teamId;
@end

NS_ASSUME_NONNULL_END
