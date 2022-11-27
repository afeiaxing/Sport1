//
//  QYZYScheduleTableViewCell.h
//  QYZY
//
//  Created by jspatches on 2022/9/29.
//

#import <UIKit/UIKit.h>
#import "QYZYMatchListInfoDetailModel.h"
#import "QYZYMyreserModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^QYZYTableViewnCellBookBlock)(void);

typedef NS_ENUM(NSInteger , ScheduleType) {
    ScheduleTypeLiveMain = 0,         /// 直播首页赛程时间样式为 HH:mm  这是默认样式，可不设置scheduleType
    ScheduleTypeLiveDetailNotice = 1, /// 直播详情预告时间样式为 yyyy-MM-dd HH:mm
};

@interface QYZYScheduleTableViewCell : UITableViewCell


@property (nonatomic, copy) QYZYTableViewnCellBookBlock actionBlock;

//赛程
- (void)updataUI:(QYZYMatchListInfoDetailModel *)model;

//预约
- (void)myreserDataUI:(QYZYMyreserModel *)model;

@property (nonatomic,strong)UIView *backView;
@property (nonatomic,assign)ScheduleType scheduleType;
/**
 联赛名称
 */
@property (nonatomic,strong)UILabel *league;
/**
 比赛状态
 */
@property (nonatomic,strong)UILabel *state;
/**
 主队名称
 */
@property (nonatomic,strong)UILabel *homeTeamName;
/**
 客队名称
 */
@property (nonatomic,strong)UILabel *visitingTeamName;
/**
 主队得分
 */
@property (nonatomic,strong)UILabel *hometeamscores;

/**
 --
 */
@property (nonatomic,strong)UILabel *vs;

/**
 客队得分
 */
@property (nonatomic,strong)UILabel *visitingteamscored;

/**
 主队队标
 */
@property (nonatomic,strong)UIImageView *hometeamImageView;

/**
 客队队标
 */
@property (nonatomic,strong)UIImageView *visitorImageView;

/**
 预约
 */
@property (nonatomic,strong)UIButton *appointmentButton;


@end

NS_ASSUME_NONNULL_END
