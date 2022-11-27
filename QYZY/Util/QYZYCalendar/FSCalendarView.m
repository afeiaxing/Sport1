//
//  FSCalendarView.m
//  Test
//
//  Created by 樊盛 on 2019/5/6.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#import "FSCalendarView.h"
#import "FSCalendarHeaderView.h"
#import "NSDate+FSCalendar.h"

@interface FSCalendarView ()

/** 日历头view（日、一、二、三...） */
@property (nonatomic, strong) FSCalendarHeaderView *calendarHeaderView;

@property (nonatomic, assign) FSCalendarViewType viewType;
/// 最大选择范围
@property (nonatomic, assign) int selectDayLimit;

@end

@implementation FSCalendarView

- (instancetype)initWithFrame: (CGRect)frame
                     viewType: (FSCalendarViewType)viewType
               selectDayLimit: (int)selectDayLimit {
    if (self = [super initWithFrame:frame]) {
        self.viewType = viewType;
        self.selectDayLimit = selectDayLimit;
        self.backgroundColor = UIColor.whiteColor;
        [self initCalendarHeaderViewWithFrame:frame withCalendarHeaderViewHeight:kCalendarHeaderViewHeight];
        [self initFSCalendarScrollViewWithFrame:frame withCalendarScrollViewHeight:frame.size.height-kCalendarHeaderViewHeight - kCalendarCustomViewHeight];
        CGFloat originY = CGRectGetMaxY(self.calendarScrollView.frame);
        
        [self initCustomViewWithFrame:frame withCustomViewOriginY:originY];
    
        [self showAllView:YES];
    }
    return self;
}

#pragma mark ---- 创建日历头view ----
- (void)initCalendarHeaderViewWithFrame:(CGRect)frame withCalendarHeaderViewHeight:(CGFloat)calendarHeaderViewHeight {
    
    NSMutableArray *days = [@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"] mutableCopy];
    self.calendarHeaderView = [[FSCalendarHeaderView alloc] initWithFrame:CGRectMake(14, 0, frame.size.width - 14 * 2, calendarHeaderViewHeight) withWeekNameArray:days];
    weakSelf(self)
    self.calendarHeaderView.switchBlock = ^(BOOL isNextMonth) {
        strongSelf(self)
        isNextMonth ? [self.calendarScrollView handleScrollToNextMonth] : [self.calendarScrollView handleScrollToLastMonth];
    };
    [self addSubview:self.calendarHeaderView];
}

#pragma mark ---- 创建日历view ----
- (void)initFSCalendarScrollViewWithFrame:(CGRect)frame withCalendarScrollViewHeight:(CGFloat)calendarScrollViewHeight{
    
    self.calendarScrollView = [[FSCalendarScrollView alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(self.calendarHeaderView.frame) + 5, frame.size.width - 14 * 2, calendarScrollViewHeight) viewType:self.viewType selectDayLimit:self.selectDayLimit];
    __weak typeof(self)weakSelf = self;
    self.calendarScrollView.passDateBlock = ^(NSDate *date) {// 点击某一天的block回调
        if ([weakSelf.fsDelegate respondsToSelector:@selector(calendarDidSelectedWithDate:)]) {
            [weakSelf.fsDelegate calendarDidSelectedWithDate:date];
            [weakSelf.calendarHeaderView handleUpdateDate:date];
        }
        
        NSArray *todayDate = [[NSDate getDateStringWithDate:[NSDate date] formatter:@"yyyy-MM"] componentsSeparatedByString:@"-"];
        NSArray *selectDate = [[NSDate getDateStringWithDate:[NSDate date] formatter:@"yyyy-MM"] componentsSeparatedByString:@"-"];
        if (todayDate.count == 2 && selectDate.count == 2) {
            NSNumber *todayYear = todayDate.firstObject;
            NSNumber *todayMonth = todayDate.lastObject;
            NSInteger day = [[NSDate date] getDay];
            NSNumber *selectedYear = selectDate.firstObject;
            NSNumber *selectedMonth = selectDate.lastObject;
            
            NSString *lastDay = [[[NSDate date] endOfMonth] xm_stringWithFormat:@"dd"];  // 当月的最后一天
            
//            NSDateComponents *dayObj = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:[NSDate date] toDate:date options:0];
//            NSDateComponents *monthObj = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:[NSDate date] toDate:date options:0];
            
            if (weakSelf.viewType == FSCalendarViewTypeBefore) {
                weakSelf.calendarHeaderView.isNextBtnEnable = selectedYear.intValue < todayYear.intValue || selectedMonth.intValue < todayMonth.intValue;
                int yearOffset = todayYear.intValue - selectedYear.intValue;
                weakSelf.calendarHeaderView.isPreBtnEnable = !((self.selectDayLimit > 0 && yearOffset * 12 + todayMonth.intValue > selectedMonth.intValue) || day == 31);
            } else if (weakSelf.viewType == FSCalendarViewTypeLater) {
                weakSelf.calendarHeaderView.isPreBtnEnable = selectedYear.intValue > todayYear.intValue || selectedMonth.intValue > todayMonth.intValue;
                int yearOffset = selectedYear.intValue - todayYear.intValue;
                weakSelf.calendarHeaderView.isNextBtnEnable = !((self.selectDayLimit > 0 && yearOffset * 12 + selectedMonth.intValue > todayMonth.intValue) || (day == 1 && lastDay.intValue == 31));
            }
        }
    };
    self.calendarScrollView.passYearAndMonthBlock = ^(FSCalendarDateModel *model) {
        [weakSelf.calendarHeaderView handleUpdateYearAndMonth:model];
    };
    [self addSubview:self.calendarScrollView];
}

#pragma mark ---- 创建日历下方自定义view ----
- (void)initCustomViewWithFrame:(CGRect)frame withCustomViewOriginY:(CGFloat)customViewOriginY {
    
    self.customView = [[FSCalendarCustomView alloc] initWithFrame:CGRectMake(0, customViewOriginY, frame.size.width, frame.size.height-customViewOriginY)];
    weakSelf(self)
    self.customView.cancelBlock = ^{
        strongSelf(self)
        !self.cancelBlock ? : self.cancelBlock();
    };
    self.customView.conformBlock = ^{
        strongSelf(self)
        !self.conformBlock ? : self.conformBlock();
    };
    [self addSubview:self.customView];
}

#pragma mark ---- 显示全部 ----
- (void)showAllView:(BOOL)animate {
    [self.calendarScrollView setContentOffset:CGPointMake(self.calendarScrollView.bounds.size.width, 0) animated:animate];
    [UIView animateWithDuration:0.01 animations:^{
        
        CGRect rect = self.customView.frame;
        rect.origin.y = CGRectGetMaxY(self.calendarScrollView.frame);
        rect.size.height = self.frame.size.height-rect.origin.y;
        self.customView.frame = rect;
    }];
    
}

#pragma mark ---- 回到今天点击方法 ----
- (void)refreshToCurrentDate {
    
    [self.calendarScrollView refreshToCurrentDate];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
