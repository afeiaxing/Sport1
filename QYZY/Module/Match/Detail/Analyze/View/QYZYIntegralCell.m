//
//  QYZYIntegralCell.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYIntegralCell.h"
@interface QYZYIntegralCell ()
@property (nonatomic, strong) UIImageView *teamIcon;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UILabel *racedLabel;
@property (nonatomic, strong) UILabel *winBurdenFlatLabel;
@property (nonatomic, strong) UILabel *haveLoseLabel;
@property (nonatomic, strong) UILabel *integralLabel;
@end
@implementation QYZYIntegralCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubview];
    }
    return self;
}

- (void)setSubview {
    [self.contentView addSubview:self.teamIcon];
    [self.contentView addSubview:self.rankLabel];
    [self.contentView addSubview:self.racedLabel];
    [self.contentView addSubview:self.winBurdenFlatLabel];
    [self.contentView addSubview:self.haveLoseLabel];
    [self.contentView addSubview:self.integralLabel];
    [self.teamIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.teamIcon.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(46, 16));
    }];

    [self.racedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_centerX);
        make.left.equalTo(self.rankLabel.mas_right);
        make.height.equalTo(@16);
    }];

    [self.winBurdenFlatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(62, 16));
    }];

    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(46, 16));
    }];

    [self.haveLoseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.winBurdenFlatLabel.mas_right);
        make.right.equalTo(self.integralLabel.mas_left);
        make.height.mas_equalTo(16);
    }];
}

- (void)setSubModel:(QYZYMatchAnalyzeRankSubModel *)subModel {
    _subModel = subModel;
    [self.teamIcon sd_setImageWithURL:[NSURL URLWithString:subModel.logo]];
    if (self.isBasket) {
        self.rankLabel.text = [NSString stringWithFormat:@"%@%@",[NSString isEmptyString:subModel.depart] ? @"排名" : subModel.depart , [NSString isEmptyString:subModel.teamRank] ? @"-" : subModel.teamRank];
        self.racedLabel.text = [NSString stringWithFormat:@"%@-%@",[NSString isEmptyString:subModel.win] ? @"-" : subModel.win,[NSString isEmptyString:subModel.lost] ? @"-" : subModel.lost];
        self.winBurdenFlatLabel.text = [NSString notEmptyFloatString:subModel.points length:1];
        self.haveLoseLabel.text = [NSString notEmptyFloatString:subModel.lostPoints length:1];
        if(subModel.continuousStatus > 0) {
            self.integralLabel.text = [NSString stringWithFormat:@"%ld连胜", labs(subModel.continuousStatus)];
        } else if (subModel.continuousStatus < 0) {
            self.integralLabel.text = [NSString stringWithFormat:@"%ld连败", labs(subModel.continuousStatus)];
        } else {
            self.integralLabel.text = @"-";
        }
    }
    else {
        self.rankLabel.text = [NSString stringWithFormat:@"%@%@",[NSString isEmptyString:subModel.leagueName] ? @"-" : subModel.leagueName , [NSString isEmptyString:subModel.teamRank] ? @"-" : subModel.teamRank];
        self.racedLabel.text = [NSString isEmptyString:subModel.matchCount] ? @"-" : subModel.matchCount;
        self.winBurdenFlatLabel.text = [NSString stringWithFormat:@"%@/%@/%@",[NSString isEmptyString:subModel.win] ? @"-" : subModel.win,[NSString isEmptyString:subModel.draw] ? @"-" : subModel.draw,[NSString isEmptyString:subModel.lost] ? @"-" : subModel.lost];
        self.haveLoseLabel.text = [NSString stringWithFormat:@"%@/%@",[NSString isEmptyString:subModel.goal] ? @"-" : subModel.goal,[NSString isEmptyString:subModel.lostGoal] ? @"-" : subModel.lostGoal];
        self.integralLabel.text = [NSString isEmptyString:subModel.point] ? @"-" : subModel.point;
    }
}

- (UIImageView *)teamIcon {
    if (!_teamIcon) {
        _teamIcon = [[UIImageView alloc] init];
        _teamIcon.backgroundColor = rgb(246, 247, 249);
    }
    return _teamIcon;
}


- (UILabel *)rankLabel {
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = rgb(149, 157, 176);
        _rankLabel.text = @"-";
        _rankLabel.font = [UIFont systemFontOfSize:11];
    }
    return _rankLabel;
}


- (UILabel *)racedLabel {
    if (!_racedLabel) {
        _racedLabel = [[UILabel alloc] init];
        _racedLabel.textColor = rgb(149, 157, 176);
        _racedLabel.text = @"-";
        _racedLabel.font = [UIFont systemFontOfSize:11];
        _racedLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _racedLabel;
}

- (UILabel *)winBurdenFlatLabel {
    if (!_winBurdenFlatLabel) {
        _winBurdenFlatLabel = [[UILabel alloc] init];
        _winBurdenFlatLabel.textColor = rgb(149, 157, 176);
        _winBurdenFlatLabel.text = @"-";
        _winBurdenFlatLabel.font = [UIFont systemFontOfSize:11];
        _winBurdenFlatLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _winBurdenFlatLabel;
}

- (UILabel *)haveLoseLabel {
    if (!_haveLoseLabel) {
        _haveLoseLabel = [[UILabel alloc] init];
        _haveLoseLabel.textColor = rgb(149, 157, 176);
        _haveLoseLabel.text = @"-";
        _haveLoseLabel.font = [UIFont systemFontOfSize:11];
        _haveLoseLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _haveLoseLabel;
}

- (UILabel *)integralLabel {
    if (!_integralLabel) {
        _integralLabel = [[UILabel alloc] init];
        _integralLabel.textColor = rgb(149, 157, 176);
        _integralLabel.text = @"-";
        _integralLabel.font = [UIFont systemFontOfSize:11];
        _integralLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _integralLabel;
}


@end
