//
//  QYZYIntegralHeaderView.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYIntegralHeaderView.h"

@interface QYZYIntegralHeaderView ()
@property (nonatomic, strong) UILabel *teamLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *racedLabel;
@property (nonatomic, strong) UILabel *winBurdenFlatLabel;
@property (nonatomic, strong) UILabel *haveLoseLabel;
@property (nonatomic, strong) UILabel *integralLabel;
@end

@implementation QYZYIntegralHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = rgb(246, 247, 249);

        [self setSubview];
    }
    return self;
}

- (void)setSubview {
    [self addSubview:self.teamLabel];
    [self addSubview:self.rankLabel];
    [self addSubview:self.racedLabel];
    [self addSubview:self.winBurdenFlatLabel];
    [self addSubview:self.haveLoseLabel];
    [self addSubview:self.integralLabel];
    [self.teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(46, 16));
    }];

    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.teamLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(46, 16));
    }];

    [self.racedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.mas_centerX);
        make.left.equalTo(self.rankLabel.mas_right);
        make.height.equalTo(@16);
    }];

    [self.winBurdenFlatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(62, 16));
    }];

    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(46, 16));
    }];

    [self.haveLoseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.winBurdenFlatLabel.mas_right);
        make.right.equalTo(self.integralLabel.mas_left);
        make.height.mas_equalTo(16);
    }];
}

- (void)setIsBasket:(BOOL)isBasket {
    _isBasket = isBasket;
    self.racedLabel.text = isBasket ? @"胜-负" : @"已赛";
    self.winBurdenFlatLabel.text = isBasket ? @"均得分" : @"胜/平/负";
    self.haveLoseLabel.text = isBasket ? @"均失分" : @"得/失";
    self.integralLabel.text = isBasket ? @"状态" : @"积分";
}

- (UILabel *)teamLabel {
    if (!_teamLabel) {
        _teamLabel = [[UILabel alloc] init];
        _teamLabel.textColor = rgb(149, 157, 176);
        _teamLabel.text = @"球队";
        _teamLabel.font = [UIFont systemFontOfSize:11];
        _teamLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _teamLabel;
}


- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = rgb(149, 157, 176);
        _rankLabel.text = @"排名";
        _rankLabel.font = [UIFont systemFontOfSize:11];
    }
    return _rankLabel;
}


- (UILabel *)racedLabel {
    if (!_racedLabel) {
        _racedLabel = [[UILabel alloc] init];
        _racedLabel.textColor = rgb(149, 157, 176);
        _racedLabel.text = self.isBasket ? @"胜-负" : @"已赛";
        _racedLabel.font = [UIFont systemFontOfSize:11];
        _racedLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _racedLabel;
}

- (UILabel *)winBurdenFlatLabel {
    if (!_winBurdenFlatLabel) {
        _winBurdenFlatLabel = [[UILabel alloc] init];
        _winBurdenFlatLabel.textColor = rgb(149, 157, 176);
        _winBurdenFlatLabel.text = self.isBasket ? @"均得分" : @"胜/平/负";
        _winBurdenFlatLabel.font = [UIFont systemFontOfSize:11];
        _winBurdenFlatLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _winBurdenFlatLabel;
}

- (UILabel *)haveLoseLabel {
    if (!_haveLoseLabel) {
        _haveLoseLabel = [[UILabel alloc] init];
        _haveLoseLabel.textColor = rgb(149, 157, 176);
        _haveLoseLabel.text = self.isBasket ? @"均失分" : @"得/失";
        _haveLoseLabel.font = [UIFont systemFontOfSize:11];
        _haveLoseLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _haveLoseLabel;
}

- (UILabel *)integralLabel {
    if (!_integralLabel) {
        _integralLabel = [[UILabel alloc] init];
        _integralLabel.textColor = rgb(149, 157, 176);
        _integralLabel.text = self.isBasket ? @"状态" : @"积分";
        _integralLabel.font = [UIFont systemFontOfSize:11];
        _integralLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _integralLabel;
}

@end
