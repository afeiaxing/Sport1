//
//  FSCalendarHeaderView.h
//  Test
//
//  Created by 樊盛 on 2019/5/8.
//  Copyright © 2019年 樊盛. All rights reserved.
//  日历headerView（日、一、二、三、四、五、六）

#import <UIKit/UIKit.h>
#import "FSCalendarDateModel.h"

typedef void (^FSCalendarHeaderSwitchBlock)(BOOL isNextMonth);

@interface FSCalendarHeaderView : UIView

@property (nonatomic, assign) BOOL isPreBtnEnable;
@property (nonatomic, assign) BOOL isNextBtnEnable;

@property (nonatomic, copy) FSCalendarHeaderSwitchBlock switchBlock;

/** 日历headerView 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame withWeekNameArray:(NSArray *)weekNameArray;

- (void)handleUpdateDate: (NSDate *)date;

- (void)handleUpdateYearAndMonth: (FSCalendarDateModel *)model;

@end
