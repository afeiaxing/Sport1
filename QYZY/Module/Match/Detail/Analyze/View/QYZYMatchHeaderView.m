//
//  QYZYMatchHeaderView.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYMatchHeaderView.h"

@interface QYZYMatchHeaderView ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *matchLabel;
@property (nonatomic, strong) UILabel *againstLabel;
@property (nonatomic, strong) UILabel *intervalLabel;
@end

@implementation QYZYMatchHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = rgb(246, 247, 249);

        [self setSubview];
    }
    return self;
}

- (void)setSubview {
    [self addSubview:self.timeLabel];
    [self addSubview:self.matchLabel];
    [self addSubview:self.againstLabel];
    [self addSubview:self.intervalLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.mas_equalTo(ScreenWidth / 5);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
    
    [self.matchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLabel.mas_right);
        make.width.mas_equalTo(ScreenWidth / 5);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
    
    [self.againstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.matchLabel.mas_right);
        make.width.mas_equalTo(2 * ScreenWidth / 5);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
    
    [self.intervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.againstLabel.mas_right);
        make.width.mas_equalTo(ScreenWidth / 5);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = rgb(149, 157, 176);
        _timeLabel.text = @"时间";
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)matchLabel {
    if (!_matchLabel) {
        _matchLabel = [[UILabel alloc] init];
        _matchLabel.textColor = rgb(149, 157, 176);
        _matchLabel.text = @"赛事";
        _matchLabel.textAlignment = NSTextAlignmentCenter;
        _matchLabel.font = [UIFont systemFontOfSize:11];
    }
    return _matchLabel;
}


- (UILabel *)againstLabel {
    if (!_againstLabel) {
        _againstLabel = [[UILabel alloc] init];
        _againstLabel.textColor = rgb(149, 157, 176);
        _againstLabel.text = @"比赛对阵";
        _againstLabel.font = [UIFont systemFontOfSize:11];
        _againstLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _againstLabel;
}

- (UILabel *)intervalLabel {
    if (!_intervalLabel) {
        _intervalLabel = [[UILabel alloc] init];
        _intervalLabel.textColor = rgb(149, 157, 176);
        _intervalLabel.text = @"间隔";
        _intervalLabel.font = [UIFont systemFontOfSize:11];
        _intervalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _intervalLabel;
}

@end
