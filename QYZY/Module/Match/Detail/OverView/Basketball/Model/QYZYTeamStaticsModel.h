//
//  QYZYTeamStaticsModel.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYTeamStaticsModel : NSObject

/// 主队篮板个数
@property (nonatomic, copy) NSString *hostRbnd;
/// 客队篮板个数
@property (nonatomic, copy) NSString *guestRbnd;
/// 主队盖帽数
@property (nonatomic, copy) NSString *hostBlckSht;
/// 客队盖帽数
@property (nonatomic, copy) NSString *guestBlckSht;
/// 主队助攻数
@property (nonatomic, copy) NSString *hostAssist;
/// 客队助攻数
@property (nonatomic, copy) NSString *guestAssist;
/// 主队抢断数
@property (nonatomic, copy) NSString *hostSteal;
/// 客队抢断数
@property (nonatomic, copy) NSString *guestSteal;
/// 主队失误数
@property (nonatomic, copy) NSString *hostTurnover;
/// 客队失误数
@property (nonatomic, copy) NSString *guestTurnover;
/// 主队控球时间比率
@property (nonatomic, copy) NSString *hostPossessionRate;
/// 客队控球时间比率
@property (nonatomic, copy) NSString *guestPossessionRate;
/// 主队进攻篮板
@property (nonatomic, copy) NSString *hostOffensiveRebound;
/// 客队进攻篮板
@property (nonatomic, copy) NSString *guestOffensiveRebound;
/// 主队防守篮板
@property (nonatomic, copy) NSString *hostDefensiveRebound;
/// 客队防守篮板
@property (nonatomic, copy) NSString *guestDefensiveRebound;
/// 主队得分
@property (nonatomic, copy) NSString *hostPoint;
/// 客队得分
@property (nonatomic, copy) NSString *guestPoint;
/// 主队投篮
@property (nonatomic, copy) NSString *hostThrow;
/// 客队投篮
@property (nonatomic, copy) NSString *guestThrow;
/// 主队投篮命中
@property (nonatomic, copy) NSString *hostThrowPoint;
/// 客队投篮命中
@property (nonatomic, copy) NSString *guestThrowPoint;

/// 主队三分个数
@property (nonatomic, copy) NSString *hostThrPnt;
/// 客队三分个数
@property (nonatomic, copy) NSString *guestThrPnt;
/// 主队三分命中
@property (nonatomic, copy) NSString *hostThrPntMade;
/// 客队三分命中
@property (nonatomic, copy) NSString *guestThrPntMade;

/// 主队罚球个数
@property (nonatomic, copy) NSString *hostPnlty;
/// 客队罚球个数
@property (nonatomic, copy) NSString *guestPnlty;
/// 主队罚球命中
@property (nonatomic, copy) NSString *hostPnltyPoint;
/// 客队罚球命中
@property (nonatomic, copy) NSString *guestPnltyPoint;

/// 2分个数
@property (nonatomic, copy) NSString *hostTwoPointAttempted;
/// 2分个数
@property (nonatomic, copy) NSString *guestTwoPointAttempted;
/// 2分命中
@property (nonatomic, copy) NSString *hostTwoPointMade;
/// 2分命中
@property (nonatomic, copy) NSString *guestTwoPointMade;

/// 剩余暂停
@property (nonatomic, copy) NSString *hostRemainingPause;
/// 剩余暂停
@property (nonatomic, copy) NSString *guestRemainingPause;
/// 本节犯规
@property (nonatomic, copy) NSString *hostThisFoul;
/// 本节犯规
@property (nonatomic, copy) NSString *guestThisFoul;

@end

NS_ASSUME_NONNULL_END
