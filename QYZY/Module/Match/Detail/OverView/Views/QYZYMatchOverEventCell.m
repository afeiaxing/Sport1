//
//  QYZYMatchOverEventCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/23.
//

#import "QYZYMatchOverEventCell.h"

@interface QYZYMatchOverEventCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (nonatomic ,strong) UIView *containerView;
@property (nonatomic ,strong) UIImageView *iconView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *subLabel;
@property (nonatomic ,strong) UIImageView *stateImageView;
@property (nonatomic ,strong) UILabel *locationLabel;
@end

@implementation QYZYMatchOverEventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.iconView];
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.subLabel];
    [self.contentView addSubview:self.stateImageView];
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.center.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(25);
        make.right.equalTo(self.contentView).offset(-25);
        make.height.mas_equalTo(52);
    }];
}

- (void)setEventModel:(QYZYMatchEventModel *)eventModel {
    _eventModel = eventModel;
    if (eventModel.team.integerValue == 2) {
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.subLabel.textAlignment = NSTextAlignmentLeft;
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.left.equalTo(self.contentView.mas_centerX).offset(20);
            make.height.mas_equalTo(56);
            make.centerY.equalTo(self.contentView);
        }];
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.containerView).offset(8);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).offset(36);
            make.right.equalTo(self.containerView).offset(-18);
            make.top.equalTo(self.containerView).offset(12);
            make.height.mas_equalTo(14);
        }];
        [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView).offset(36);
            make.right.equalTo(self.containerView).offset(-18);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(14);
        }];
    } else {
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.subLabel.textAlignment = NSTextAlignmentRight;
        [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.right.equalTo(self.contentView.mas_centerX).offset(-20);
            make.height.mas_equalTo(56);
            make.centerY.equalTo(self.contentView);
        }];
        [self.iconView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(20);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.containerView).offset(-8);
        }];
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containerView).offset(-36);
            make.left.equalTo(self.containerView).offset(18);
            make.top.equalTo(self.containerView).offset(12);
            make.height.mas_equalTo(14);
        }];
        [self.subLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.containerView).offset(-36);
            make.left.equalTo(self.containerView).offset(18);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
            make.height.mas_equalTo(14);
        }];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@'", [NSString stringWithFormat:@"%02ld",(NSInteger)ceil(eventModel.occurTime.integerValue/60.0)]];
    // 加时时间
    if (eventModel.overTime.integerValue > 0) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@+%@'",self.timeLabel.text,[NSString stringWithFormat:@"%ld",eventModel.overTime.integerValue]];
    }
    // 数据处理
    NSString *stateImageName = @"";
    NSString *imageName = @"";
    self.locationLabel.hidden = YES;
    self.topLineView.hidden = NO;
    self.bottomLineView.hidden = NO;
    switch (eventModel.typeId.integerValue) {
            // 场地信息
        case 0:
            self.locationLabel.hidden = NO;
            self.locationLabel.text = eventModel.content;
            break;
            // 比赛开始
        case 1:
            stateImageName = @"match_over_start";
            self.bottomLineView.hidden = YES;
            break;
            // 比赛结束
        case 3:
            stateImageName = @"match_over_end";
            self.topLineView.hidden = YES;
            break;
            // 加时赛开始
        case 6:
        case 139:
            stateImageName = @"match_over_add";
            break;
            // 进球
        case 9:
            // 进球
            self.subLabel.text = eventModel.content2;
            if (eventModel.goalType.integerValue == 1) {
                imageName = @"match_over_goal";
                self.titleLabel.text = eventModel.playerName;
            }
            // 乌龙球
            else if(eventModel.goalType.integerValue == 2) {
                imageName = @"match_over_wu";
            }
            // 点球
            else if(eventModel.goalType.integerValue == 4 || eventModel.goalType.integerValue == 5) {
                
                imageName = @"match_over_clip";
            }
            break;
            // 中场
        case 13:
            stateImageName = @"match_over_middle";
            break;
            // 黄牌
        case 18:
            self.subLabel.text = eventModel.playerName;
            self.titleLabel.text = eventModel.content;
            imageName = @"match_over_yellow";
            break;
            
            // 红牌
        case 22:
            self.subLabel.text = eventModel.playerName;
            self.titleLabel.text = eventModel.content;
            imageName = @"match_over_red";
            break;
            // 换人
        case 23:
            imageName = @"match_over_change";
            if (eventModel.playerName2.length) {
                self.titleLabel.text = eventModel.playerName;
            }
            self.subLabel.text = eventModel.playerName2;
            break;
            // 点球射失
        case 40:
            imageName = @"match_over_ss";
            self.subLabel.text = eventModel.playerName;
            self.titleLabel.text = eventModel.content2;
            break;
        default:
            break;
    }
    self.stateImageView.hidden = !stateImageName.length;
    if (stateImageName.length) {
        self.stateImageView.image = [UIImage imageNamed:stateImageName];
    }
    if (imageName.length) {
        self.iconView.image = [UIImage imageNamed:imageName];
    }
    self.timeLabel.hidden = stateImageName.length;
    self.containerView.hidden = stateImageName.length;
    if (self.locationLabel.hidden == NO) {
        self.timeLabel.hidden = YES;
        self.topLineView.hidden = YES;
        self.bottomLineView.hidden = YES;
        self.stateImageView.hidden = YES;
        self.containerView.hidden = YES;
    }
}

#pragma mark - get
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = rgb(244, 246, 255);
        _containerView.layer.cornerRadius = 6;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = rgb(34, 34, 34);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _titleLabel;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.textColor = rgb(149, 157, 176);
        _subLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _subLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UIImageView *)stateImageView {
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] init];
        _stateImageView.hidden = YES;
    }
    return _stateImageView;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.textColor = rgb(149, 157, 176);
        _locationLabel.textAlignment = NSTextAlignmentCenter;
        _locationLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _locationLabel.layer.cornerRadius = 6;
        _locationLabel.layer.masksToBounds = YES;
        _locationLabel.layer.borderColor = rgb(233, 237, 247).CGColor;
        _locationLabel.layer.borderWidth = 1;
        _locationLabel.backgroundColor = UIColor.whiteColor;
        _locationLabel.hidden = YES;
    }
    return _locationLabel;
}

@end
