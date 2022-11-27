//
//  QYZYMatchViewModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import <Foundation/Foundation.h>
#import "QYZYMatchModel.h"
#import "QYZYMatchMainModel.h"
#import "QYZYMatchOverModel.h"
#import "QYZYMatchEventModel.h"
#import "QYZYMatchAnalyzeRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchViewModel : NSObject
@property (nonatomic ,assign) QYZYMatchType matchType;
@property (nonatomic ,assign) BOOL isBasket; /// 是否篮球，默认否
- (void)requestMatchDataWithDateString:(NSString *)dateString completion:(void(^)(QYZYMatchModel *matchModel))completion;
- (void)requestMatchDetailWithMatchId:(NSString *)matchId completion:(void(^)(QYZYMatchMainModel *detailModel))completion;
- (void)requestMatchOverPhraseWithMatchId:(NSString *)matchId completion:(void(^)(NSArray <QYZYMatchOverModel *> *overArray))completion;
- (void)requestMatchOverEventWithMatchId:(NSString *)matchId completion:(void(^)(NSArray <QYZYMatchOverModel *> *overArray))completion;
- (void)requestAnalyzeHistoryWithMatchId:(NSString *)matchId hostTeamId:(NSString *)hostTeamId guestTeamId:(NSString *)guestTeamId completion:(void(^)(QYZYSubMatchModel *model))completion;

- (void)requestAnalyzeHistoryWithMatchId:(NSString *)matchId
                              hostTeamId:(NSString *)hostTeamId
                             guestTeamId:(NSString *)guestTeamId
                                leagueId:(NSString *)leagueId
                         isSameHostGuest:(BOOL)isSameHostGuest
                            isSameLeague:(BOOL)isSameLeague
                             completion:(void(^)(QYZYSubMatchModel *model))completion;

- (void)requestMatchEventWithMatchId:(NSString *)matchId completion:(void(^)(NSArray <QYZYMatchEventModel *> *eventArray))completion;
- (void)requestMatchAnalyzeIntegralWithMatchId:(NSString *)matchId hostTeamId:(NSString *)hostTeamId guestTeamId:(NSString *)guestTeamId completion:(void(^)(QYZYMatchAnalyzeRankModel *analyzeRankModel))completion;
- (void)requestBasketballMatchScoreWithMatchId:(NSString *)matchId completion:(void(^)(id data))completion;


- (void)requestAnalyzeRecentWithMatchId:(NSString *)matchId
                                 teamId:(NSString *)teamId
                                   side:(NSString *)side
                               leagueId:(NSString *)leagueId
                        isSameHostGuest:(BOOL)isSameHostGuest
                           isSameLeague:(BOOL)isSameLeague
                             completion:(void(^)(QYZYSubMatchModel *model))completion;

- (void)requestMatchFutureRecordsWithMatchId:(NSString *)matchId teamId:(NSString *)teamId completion:(void(^)(NSArray <QYZYMatchMainModel *> *matches))completion;
@end

NS_ASSUME_NONNULL_END
