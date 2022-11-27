//
//  QYZYPlayerDataModel.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import "QYZYPlayerInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYPlayerDataModel : NSObject
/// 上场时间
@property (nonatomic, assign) NSInteger playTime;
/// 得分
@property (nonatomic, assign) NSInteger point;
/// 篮板
@property (nonatomic, assign) NSInteger rebound;
/// 助攻
@property (nonatomic, assign) NSInteger assist;
/// 投进数
@property (nonatomic, assign) NSInteger fieldGoalMade;
/// 投球数
@property (nonatomic, assign) NSInteger fieldGoalAttempted;
/// 三分球投进数
@property (nonatomic, assign) NSInteger threePointMade;
/// 三分球投球数
@property (nonatomic, assign) NSInteger threePointAttempted;
/// 罚球投进数
@property (nonatomic, assign) NSInteger freeThrowMade;
/// 罚球投球数
@property (nonatomic, assign) NSInteger freeThrowAttempted;
/// 抢断
@property (nonatomic, assign) NSInteger steal;
/// 封盖
@property (nonatomic, assign) NSInteger block;
/// 失误
@property (nonatomic, assign) NSInteger turnover;
/// 犯规
@property (nonatomic, assign) NSInteger foul;
/// 球队 名称
@property (nonatomic, copy) NSString *teamName;
/// 教练名称
@property (nonatomic, copy) NSString *coachName;

@property (nonatomic, strong) NSArray<QYZYPlayerInfoModel *> *playerStats;

@end

NS_ASSUME_NONNULL_END
