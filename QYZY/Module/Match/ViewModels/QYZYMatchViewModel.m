//
//  QYZYMatchViewModel.m
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import "QYZYMatchViewModel.h"
#import "QYZYMatchApi.h"
#import "QYZYMatchDetailApi.h"
#import "QYZYMatchOverPhraseApi.h"
#import "QYZYMatchOverEventApi.h"
#import "QYZYAnalyzeHistoryApi.h"
#import "QYZYAnalyzeRecentApi.h"
#import "QYZYMatchEventApi.h"
#import "QYZYAnalyzeIntegralApi.h"
#import "QYZYFutureRecordsApi.h"

@implementation QYZYMatchViewModel
- (void)requestMatchDataWithDateString:(NSString *)dateString completion:(void(^)(QYZYMatchModel *matchModel))completion{
    QYZYMatchApi *api = [[QYZYMatchApi alloc] init];
    api.currentDateString = dateString;
    api.matchType = self.matchType;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYMatchModel *matchModel = [QYZYMatchModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        !completion ? : completion(matchModel);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ? : completion(nil);
    }];
}

- (void)requestMatchDetailWithMatchId:(NSString *)matchId completion:(void(^)(QYZYMatchMainModel *detailModel))completion {
    QYZYMatchDetailApi *api = [[QYZYMatchDetailApi alloc] init];
    api.matchId = matchId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYMatchMainModel *model = [QYZYMatchMainModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        !completion ?: completion(model);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestMatchOverPhraseWithMatchId:(NSString *)matchId completion:(void(^)(NSArray <QYZYMatchOverModel *> *overArray))completion {
    QYZYMatchOverPhraseApi *api = [[QYZYMatchOverPhraseApi alloc] init];
    api.matchId = matchId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <QYZYMatchOverModel *> *array = [NSArray yy_modelArrayWithClass:QYZYMatchOverModel.class json:request.responseJSONObject[@"data"]];
        !completion ?: completion(array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestMatchOverEventWithMatchId:(NSString *)matchId completion:(void(^)(NSArray <QYZYMatchOverModel *> *overArray))completion {
    QYZYMatchOverEventApi *api = [[QYZYMatchOverEventApi alloc] init];
    api.matchId = matchId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <QYZYMatchOverModel *> *array = [NSArray yy_modelArrayWithClass:QYZYMatchOverModel.class json:request.responseJSONObject[@"data"][@"events"]];
        [array enumerateObjectsUsingBlock:^(QYZYMatchOverModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.isBasket = self.isBasket;
        }];
        if (self.isBasket) {
            NSMutableArray <QYZYMatchOverModel *> *firstArray = [NSMutableArray array];
            NSMutableArray <QYZYMatchOverModel *> *secondArray = [NSMutableArray array];
            NSMutableArray <QYZYMatchOverModel *> *thirdArray = [NSMutableArray array];
            NSMutableArray <QYZYMatchOverModel *> *fourArray = [NSMutableArray array];
            NSMutableArray <QYZYMatchOverModel *> *finishArray = [NSMutableArray array];
            [array enumerateObjectsUsingBlock:^(QYZYMatchOverModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.statusName isEqualToString:@"第一节"]) {
                    [firstArray addObject:obj];
                }
                else if ([obj.statusName isEqualToString:@"第二节"]) {
                    [secondArray addObject:obj];
                }
                else if ([obj.statusName isEqualToString:@"第三节"]) {
                    [thirdArray addObject:obj];
                }
                else if ([obj.statusName isEqualToString:@"第四节"]) {
                    [fourArray addObject:obj];
                }
                else if ([obj.statusName isEqualToString:@"完场"]) {
                    [finishArray addObject:obj];
                }
            }];
            [finishArray addObjectsFromArray:fourArray];
            [finishArray addObjectsFromArray:thirdArray];
            [finishArray addObjectsFromArray:secondArray];
            [finishArray addObjectsFromArray:firstArray];
            array = finishArray;
        }
        !completion ?: completion(array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestAnalyzeHistoryWithMatchId:(NSString *)matchId
                              hostTeamId:(NSString *)hostTeamId
                             guestTeamId:(NSString *)guestTeamId
                                leagueId:(NSString *)leagueId
                         isSameHostGuest:(BOOL)isSameHostGuest
                            isSameLeague:(BOOL)isSameLeague completion:(void(^)(QYZYSubMatchModel *model))completion {
    QYZYAnalyzeHistoryApi *api = [[QYZYAnalyzeHistoryApi alloc] init];
    api.matchId = matchId;
    api.hostTeamId = hostTeamId;
    api.guestTeamId = guestTeamId;
    api.leagueId = leagueId;
    api.isSameHostGuest = isSameHostGuest;
    api.isSameLeague = isSameLeague;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYSubMatchModel *model = [QYZYSubMatchModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        !completion ?: completion(model);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestAnalyzeRecentWithMatchId:(NSString *)matchId
                                 teamId:(NSString *)teamId
                                   side:(NSString *)side
                               leagueId:(NSString *)leagueId
                        isSameHostGuest:(BOOL)isSameHostGuest
                           isSameLeague:(BOOL)isSameLeague
                             completion:(void(^)(QYZYSubMatchModel *model))completion {
    QYZYAnalyzeRecentApi *api = [[QYZYAnalyzeRecentApi alloc] init];
    api.isBasket = self.isBasket;
    api.matchId = matchId;
    api.teamId = teamId;
    if (isSameHostGuest) {
        side = isSameHostGuest ? @"host" : @"guest";
    }
    api.side = side;
    api.leagueId = isSameLeague ? leagueId : @"";
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYSubMatchModel *model = [QYZYSubMatchModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        !completion ?: completion(model);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestMatchEventWithMatchId:(NSString *)matchId completion:(void(^)(NSArray <QYZYMatchEventModel *> *eventArray))completion {
    QYZYMatchEventApi *api = [[QYZYMatchEventApi alloc] init];
    api.matchId = matchId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSMutableArray <QYZYMatchEventModel *> *tempArray = [NSMutableArray array];
        NSArray <QYZYMatchEventModel *> *array = [NSArray yy_modelArrayWithClass:QYZYMatchEventModel.class json:request.responseJSONObject[@"data"]];
        [array enumerateObjectsUsingBlock:^(QYZYMatchEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.typeId.integerValue == 0 ||
                obj.typeId.integerValue == 1 ||
                obj.typeId.integerValue == 3 ||
                obj.typeId.integerValue == 9 ||
                obj.typeId.integerValue == 13 ||
                obj.typeId.integerValue == 18 ||
                obj.typeId.integerValue == 22 ||
                obj.typeId.integerValue == 23 ||
                obj.typeId.integerValue == 6 ||
                obj.typeId.integerValue == 139) {
                [tempArray addObject:obj];
            }
        }];
        !completion ?: completion(tempArray);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestMatchAnalyzeIntegralWithMatchId:(NSString *)matchId hostTeamId:(NSString *)hostTeamId guestTeamId:(NSString *)guestTeamId completion:(void (^)(QYZYMatchAnalyzeRankModel *analyzeRankModel))completion {
    QYZYAnalyzeIntegralApi *api = [[QYZYAnalyzeIntegralApi alloc] init];
    api.isBasket = self.isBasket;
    api.matchId = matchId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYMatchAnalyzeRankModel *model = [QYZYMatchAnalyzeRankModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        
        NSMutableArray <QYZYMatchAnalyzeRankSubModel *> *sameHG = [NSMutableArray array];
        QYZYMatchAnalyzeRankSubModel *hostModel = [model.host qyzy_findFirstWithFilterBlock:^BOOL(QYZYMatchAnalyzeRankSubModel *obj) {
            return [obj.teamId isEqualToString:hostTeamId];
        }];
        if (hostModel) {
            [sameHG addObject:hostModel];
        }
        QYZYMatchAnalyzeRankSubModel *guestModel = [model.guest qyzy_findFirstWithFilterBlock:^BOOL(QYZYMatchAnalyzeRankSubModel *obj) {
            return [obj.teamId isEqualToString:guestTeamId];
        }];
        if (guestModel) {
            [sameHG addObject:guestModel];
        }
        model.sameHostGuest = sameHG;
        
        NSMutableArray <QYZYMatchAnalyzeRankSubModel *> *allArray = [NSMutableArray array];
        [model.all enumerateObjectsUsingBlock:^(QYZYMatchAnalyzeRankSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.teamId isEqualToString:hostTeamId]){
                [allArray insertObject:obj atIndex:0];
            }else{
                [allArray addObject:obj];
            }
        }];
        model.all = allArray;
        
        !completion ?: completion(model);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestMatchFutureRecordsWithMatchId:(NSString *)matchId teamId:(NSString *)teamId completion:(void(^)(NSArray <QYZYMatchMainModel *> *matches))completion {
    QYZYFutureRecordsApi *api = [[QYZYFutureRecordsApi alloc] init];
    api.matchId = matchId;
    api.teamId = teamId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <QYZYMatchMainModel *> *matches = [NSArray yy_modelArrayWithClass:QYZYMatchMainModel.class json:request.responseJSONObject[@"data"][@"matches"]];
        if (matches.count > 1) {
            NSArray *array = [NSArray qyzy_arrayWithCount:2 fillBlock:^id _Nonnull(NSInteger idx) {
                return [matches objectAtIndex:idx];
            }];
            matches = array;
        }
        !completion ?: completion(matches);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !completion ?: completion(nil);
    }];
}

- (void)requestBasketballMatchScoreWithMatchId:(NSString *)matchId completion:(void (^)(id data))completion {
    
}

@end
