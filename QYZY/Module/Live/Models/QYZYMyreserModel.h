//
//  QYZYMyreserModel.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMyreserModel : NSObject

// 区分是否是主播直播预告和我的预约
@property (nonatomic, assign) BOOL isAnchor;

@property (nonatomic, copy  ) NSString *groupId;

@property (nonatomic, copy  ) NSString *enGuestTeamName;
@property (nonatomic, copy  ) NSString *enHostTeamName;
@property (nonatomic, copy  ) NSString *enLeagueName;

@property (nonatomic, copy  ) NSString *guestTeamId;
@property (nonatomic, copy  ) NSString *guestTeamLogo;
@property (nonatomic, copy  ) NSString *guestTeamName;
@property (nonatomic, assign) NSInteger guestTeamRank;
@property (nonatomic, assign) NSInteger guestTeamScore;

@property (nonatomic, copy  ) NSString *hostTeamId;
@property (nonatomic, copy  ) NSString *hostTeamLogo;
@property (nonatomic, copy  ) NSString *hostTeamName;
@property (nonatomic, assign) NSInteger hostTeamRank;
@property (nonatomic, assign) NSInteger hostTeamScore;

@property (nonatomic, assign) NSInteger level; //赛事等级
@property (nonatomic, copy  ) NSString *leagueId;
@property (nonatomic, copy  ) NSString *leagueLogo;
@property (nonatomic, copy  ) NSString *leagueName;
@property (nonatomic, copy  ) NSString *leagueColor;

@property (nonatomic, assign) BOOL isHot;
@property (nonatomic, assign) BOOL isUserHot;
@property (nonatomic, assign) BOOL hasLive;
@property (nonatomic, assign) BOOL hasVid;

@property (nonatomic, copy  ) NSString *matchId;
@property (nonatomic, copy  ) NSString *matchTime;
@property (nonatomic, copy  ) NSString *matchDateStr;
@property (nonatomic, copy  ) NSString *round;

@property (nonatomic, assign) NSInteger status; // 1 未开始 2 进行中 3 已结束 4 已取消
/// 比赛状态（主要在直播预告使用）0:未开始，40:取消，41:延期，42:推迟，43:中断
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, copy  ) NSString *statusString;
@property (nonatomic, copy  ) NSString *statusLable;

@property (nonatomic, assign) NSInteger seasonId;
//赛事类型 1，足球 2，篮球 3，棒球 5，网球
@property (nonatomic, assign) NSInteger sportType;
@property (nonatomic, assign) NSInteger sportId;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger orderId; //预约ID
@property (nonatomic, copy  ) NSString *tournamentName; //联赛名称
@property (nonatomic, assign) BOOL userIsAppointment; //是否已预约 trues以预约false未预约
@property (nonatomic, assign) BOOL userIsAppointmentModify;

@property (nonatomic, copy  ) NSString *anchorId;

// anchorTipText 主播 提示语
@property (nonatomic, copy  ) NSString *anchorTipText;
// anchorAvatarArray 主播 头像 数组
@property (nonatomic, strong) NSArray <NSString *>*anchorAvatarArray;



@end




NS_ASSUME_NONNULL_END
