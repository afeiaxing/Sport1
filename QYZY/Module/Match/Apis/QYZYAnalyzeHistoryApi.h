//
//  QYZYAnalyzeHistoryApi.h
//  QYZY
//
//  Created by jspollo on 2022/10/14.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYAnalyzeHistoryApi : YTKRequest
@property (nonatomic, strong) NSString *matchId;
@property (nonatomic, strong) NSString *hostTeamId;
@property (nonatomic, strong) NSString *guestTeamId;
@property (nonatomic, strong) NSString *leagueId;
@property (nonatomic, assign) BOOL isSameHostGuest;
@property (nonatomic, assign) BOOL isSameLeague;
@end

NS_ASSUME_NONNULL_END
