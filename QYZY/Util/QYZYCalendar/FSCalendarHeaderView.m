//
//  FSCalendarHeaderView.m
//  Test
//
//  Created by 樊盛 on 2019/5/8.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#import "FSCalendarHeaderView.h"
#import "CalendarMacroHeader.h"

@interface FSCalendarHeaderView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIButton *preBtn;
@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation FSCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame withWeekNameArray:(NSArray *)weekNameArray {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.preBtn];
        [self addSubview:self.nextBtn];
        self.nextBtn.frame = CGRectMake(frame.size.width - 30, 65, 40, 40);
        
        self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 200) / 2, 75, 200, 20)];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        self.monthLabel.textColor = rgb(103, 108, 122);
        self.monthLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [self addSubview:self.monthLabel];
        
        [self drawWeekHeaderViewWithFrame:frame withWeekNameArray:weekNameArray];
    }
    return self;
}

- (void)handleUpdateDate: (NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSArray *temp = [dateString componentsSeparatedByString:@"-"];
    if (temp.count == 3) {
        self.monthLabel.text = [NSString stringWithFormat:@"%@年 %@月", temp[0], temp[1]];
        NSString *week;
        switch ([date weekday]) {
            case 1:
                week = @"日";
                break;
            case 2:
                week = @"一";
                break;
            case 3:
                week = @"二";
                break;
            case 4:
                week = @"三";
                break;
            case 5:
                week = @"四";
                break;
            case 6:
                week = @"五";
                break;
            case 7:
                week = @"六";
                break;
            default:
                break;
        }
        self.titleLabel.text = [NSString stringWithFormat:@"  %@年%@月%@日 周%@", temp[0], temp[1], temp[2], week];
    }
}

- (void)handleUpdateYearAndMonth: (FSCalendarDateModel *)model{
    self.monthLabel.text = [NSString stringWithFormat:@"%ld年 %ld月", model.year, model.month];
}

- (void)drawWeekHeaderViewWithFrame:(CGRect)frame withWeekNameArray:(NSArray *)weekNameArray {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 105, frame.size.width, 28)];
    bgView.backgroundColor = Color_CalendarHeaderView_Bg;
    bgView.layer.cornerRadius = 4;
    bgView.layer.masksToBounds = true;
    [self addSubview:bgView];
    
    for (int i = 0; i < weekNameArray.count; i++) {
        
        CGFloat width = frame.size.width/weekNameArray.count;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width, 0, width, 28)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = Color_Text_CalendarHeaderView_Label;
        label.font = Font_CalendarHeaderLabel;
        label.text = weekNameArray[i];
        [bgView addSubview:label];
    }
}

- (void)handlePreBtnEvent{
    !self.switchBlock ? : self.switchBlock(false);
}

- (void)handleNextBtnEvent{
    !self.switchBlock ? : self.switchBlock(true);
}

- (void)setIsPreBtnEnable:(BOOL)isPreBtnEnable{
    self.preBtn.enabled = isPreBtnEnable;
}

- (void)setIsNextBtnEnable:(BOOL)isNextBtnEnable{
    self.nextBtn.enabled = isNextBtnEnable;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-14, 0, self.bounds.size.width + 28, 64)];
        _titleLabel.textColor = UIColor.whiteColor;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
        _titleLabel.backgroundColor = rgb(41, 69, 192);
    }
    return _titleLabel;
}

- (UIButton *)preBtn{
    if (!_preBtn) {
        _preBtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, 65, 40, 40)];
        [_preBtn addTarget:self action:@selector(handlePreBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [_preBtn setImage:[UIImage imageNamed:@"calendar_left"] forState:UIControlStateNormal];
        [_preBtn setImage:[UIImage imageNamed:@"calendar_left_dis"] forState:UIControlStateDisabled];
    }
    return _preBtn;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_nextBtn addTarget:self action:@selector(handleNextBtnEvent) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setImage:[UIImage imageNamed:@"calendar_right"] forState:UIControlStateNormal];
        [_nextBtn setImage:[UIImage imageNamed:@"calendar_right_dis"] forState:UIControlStateDisabled];
    }
    return _nextBtn;
}

@end
