//
//  QYZYMatchListInfoDetailModel.h
//  QYZY
//
//  Created by jspatches on 2022/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchListInfoDetailModel : NSObject
// guestTeamLogo 客队LOGO
@property (nonatomic, copy) NSString *guestTeamLogo;
// guestTeamName 客队名称
@property (nonatomic, copy) NSString *guestTeamName;
// guestTeamScore 客队得分
@property (nonatomic, copy) NSString *guestTeamScore;
// hostTeamLogo 主队LOGO
@property (nonatomic, copy) NSString *hostTeamLogo;
// hostTeamName 主队名称
@property (nonatomic, copy) NSString *hostTeamName;
// hostTeamScore 主队得分
@property (nonatomic, copy) NSString *hostTeamScore;
// matchId 赛事ID
@property (nonatomic, copy) NSString *matchId;
// sportType 赛事类型
@property (nonatomic, copy) NSString *sportType;
// leagueName 比赛类别昵称
@property (nonatomic, copy) NSString *leagueName;
// status 比赛状态 1: 未开赛, 2: 进行中, 3: 完赛 4：异常
@property (nonatomic, copy) NSString *status;
// matchTime
@property (nonatomic, copy) NSString *matchTime;
// 是否预约
@property (nonatomic, assign) BOOL userIsAppointment;
@property (nonatomic, assign) BOOL userIsAppointmentModify;

@property (nonatomic, strong) NSString *round;
@property (nonatomic, strong) NSString *roundType;


@end

NS_ASSUME_NONNULL_END
