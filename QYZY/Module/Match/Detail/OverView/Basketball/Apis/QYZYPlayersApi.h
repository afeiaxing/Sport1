//
//  QYZYPlayersApi.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYPlayersApi : YTKRequest

@property (nonatomic, copy) NSString *matchId;

@property (nonatomic, assign) BOOL aggr;

@end

NS_ASSUME_NONNULL_END
