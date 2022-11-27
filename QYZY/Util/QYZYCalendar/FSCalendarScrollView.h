//
//  FSCalendarScrollView.h
//  Test
//
//  Created by 樊盛 on 2019/4/29.
//  Copyright © 2019年 樊盛. All rights reserved.
//  单纯的日历scrollView

#import <UIKit/UIKit.h>
#import "FSCalendarDateModel.h"

typedef void(^PassDateBlock)(NSDate *date);// 点击日期block
typedef void (^PassYearAndMonthBlock)(FSCalendarDateModel *model);

typedef NS_ENUM(NSInteger, FSCalendarViewType) {
    FSCalendarViewTypeDefault,  // 默认
    FSCalendarViewTypeBefore,   // 展示当前月之前的日期
    FSCalendarViewTypeLater     // 展示当前月之后的日期
};

@interface FSCalendarScrollView : UIScrollView

/** 日期传递block */
@property (nonatomic, copy) PassDateBlock passDateBlock;
@property (nonatomic, copy) PassYearAndMonthBlock passYearAndMonthBlock;

/** 当前月的日期 */
@property (nonatomic, strong) NSDate *currentMonthDate;

/** 当前选中的cell的日期（eg：7、19、31） */
@property (nonatomic, assign) NSInteger currentDateNumber;

/** 当前月有小圆点标记的dateString数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *pointsArray;

- (instancetype)initWithFrame: (CGRect)frame
                     viewType: (FSCalendarViewType)viewType
               selectDayLimit: (int)selectDayLimit;

/** 刷新collectionView */
- (void)reloadCollectionViews;

/** 回到今天 */
- (void)refreshToCurrentDate;

/// 滚动到下个月
- (void)handleScrollToNextMonth;

/// 滚动到上个月
- (void)handleScrollToLastMonth;

@end
