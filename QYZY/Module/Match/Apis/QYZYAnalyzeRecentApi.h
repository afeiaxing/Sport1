//
//  QYZYAnalyzeRecentApi.h
//  QYZY
//
//  Created by jspollo on 2022/10/14.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYAnalyzeRecentApi : YTKRequest
@property (nonatomic, strong) NSString *matchId;
@property (nonatomic, strong) NSString *teamId;
@property (nonatomic, strong) NSString *side;
@property (nonatomic ,assign) BOOL isBasket; /// 是否篮球，默认否
///
@property (nonatomic, strong) NSString *leagueId;
@property (nonatomic, assign) BOOL isSameHostGuest;
@end

NS_ASSUME_NONNULL_END
