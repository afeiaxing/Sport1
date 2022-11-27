//
//  QYZYMatchEventApi.h
//  QYZY
//
//  Created by jspollo on 2022/10/23.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchEventApi : YTKRequest
@property (nonatomic, strong) NSString *matchId;
@end

NS_ASSUME_NONNULL_END
