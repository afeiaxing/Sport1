//
//  QYZYMatchAnalyzeRankModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchAnalyzeRankSubModel : NSObject
@property (nonatomic ,strong) NSString *teamId;
@property (nonatomic ,strong) NSString *teamName;
@property (nonatomic ,strong) NSString *logo;
@property (nonatomic ,strong) NSString *teamRank;
@property (nonatomic ,strong) NSString *matchCount;
@property (nonatomic ,strong) NSString *win;
@property (nonatomic ,strong) NSString *draw;
@property (nonatomic ,strong) NSString *lost;
@property (nonatomic ,strong) NSString *points;
@property (nonatomic ,strong) NSString *lostPoints;
@property (nonatomic ,strong) NSString *leagueName;
@property (nonatomic ,strong) NSString *depart;
@property (nonatomic ,assign) NSInteger continuousStatus;
@property (nonatomic ,strong) NSString *goal;
@property (nonatomic ,strong) NSString *lostGoal;
@property (nonatomic ,strong) NSString *point;
@property (nonatomic ,strong) NSString *promotionId;
@property (nonatomic ,strong) NSString *promotionCnName;
@property (nonatomic ,strong) NSString *promotionEnName;
@end

@interface QYZYMatchAnalyzeRankModel : NSObject
@property (nonatomic ,strong) NSArray <QYZYMatchAnalyzeRankSubModel *> *all;
@property (nonatomic ,strong) NSArray <QYZYMatchAnalyzeRankSubModel *> *host;
@property (nonatomic ,strong) NSArray <QYZYMatchAnalyzeRankSubModel *> *guest;
@property (nonatomic ,strong) NSArray <QYZYMatchAnalyzeRankSubModel *> *sameHostGuest;
@end

NS_ASSUME_NONNULL_END
