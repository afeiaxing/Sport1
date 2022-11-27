//
//  QYZYHistoryHeaderView.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYHistoryHeaderView.h"

@interface QYZYHistoryHeaderView ()
@property (nonatomic, strong) UILabel *matchLabel;
@property (nonatomic, strong) UILabel *hostLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *awayLabel;
@property (nonatomic, strong) UILabel *cornerLabel;
@end

@implementation QYZYHistoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = rgb(246, 247, 249);

        [self setSubview];
    }
    return self;
}

- (void)setSportId:(NSString *)sportId {
    if (sportId == nil) return;
    if ([sportId isEqualToString:@"1"]) {
        self.cornerLabel.text = @"角球";
    }else {
        self.cornerLabel.text = @"总分";
    }
}

- (void)setSubview {
    [self addSubview:self.matchLabel];
    [self addSubview:self.hostLabel];
    [self addSubview:self.scoreLabel];
    [self addSubview:self.awayLabel];
    [self addSubview:self.cornerLabel];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(42, 16));
    }];
    
    [self.matchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(64, 16));
    }];

    
    
    [self.hostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.matchLabel.mas_right);
        make.right.equalTo(self.scoreLabel.mas_left);
        make.height.mas_equalTo(16);
    }];

    [self.cornerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(46, 16));
    }];

    [self.awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.scoreLabel.mas_right);
        make.right.equalTo(self.cornerLabel.mas_left);
        make.height.mas_equalTo(16);
    }];
    
}

- (UILabel *)matchLabel {
    if (!_matchLabel) {
        _matchLabel = [[UILabel alloc] init];
        _matchLabel.textColor = rgb(149, 157, 176);
        _matchLabel.text = @"赛事";
        _matchLabel.font = [UIFont systemFontOfSize:11];
        _matchLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _matchLabel;
}


- (UILabel *)hostLabel {
    if (!_hostLabel) {
        _hostLabel = [[UILabel alloc] init];
        _hostLabel.textColor = rgb(149, 157, 176);
        _hostLabel.text = @"主队";
        _hostLabel.textAlignment = NSTextAlignmentRight;
        _hostLabel.font = [UIFont systemFontOfSize:11];
    }
    return _hostLabel;
}


- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = rgb(149, 157, 176);
        _scoreLabel.text = @"比分";
        _scoreLabel.font = [UIFont systemFontOfSize:11];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLabel;
}

- (UILabel *)awayLabel {
    if (!_awayLabel) {
        _awayLabel = [[UILabel alloc] init];
        _awayLabel.textColor = rgb(149, 157, 176);
        _awayLabel.text = @"客队";
        _awayLabel.font = [UIFont systemFontOfSize:11];
    }
    return _awayLabel;
}

- (UILabel *)cornerLabel {
    if (!_cornerLabel) {
        _cornerLabel = [[UILabel alloc] init];
        _cornerLabel.textColor = rgb(149, 157, 176);
        _cornerLabel.font = [UIFont systemFontOfSize:11];
        _cornerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cornerLabel;
}


@end
