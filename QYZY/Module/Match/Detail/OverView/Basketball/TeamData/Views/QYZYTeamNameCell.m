//
//  QYZYTeamNameCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYTeamNameCell.h"

@interface QYZYTeamNameCell ()

@property (nonatomic, strong) UILabel *hintLab;

@property (nonatomic, strong) UILabel *team1Lab;

@property (nonatomic, strong) UILabel *team2Lab;

@end

@implementation QYZYTeamNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.hintLab];
    [self.hintLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.team1Lab];
    [self.contentView addSubview:self.team2Lab];
    
    [self.team1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hintLab);
        make.right.equalTo(self.hintLab.mas_left).offset(-11);
    }];
    [self.team2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hintLab);
        make.left.equalTo(self.hintLab.mas_right).offset(11);
    }];

}

- (void)setDetailModel:(QYZYMatchMainModel *)detailModel {
    _detailModel = detailModel;
    self.team1Lab.text = detailModel.hostTeamName;
    self.team2Lab.text = detailModel.guestTeamName;
}

- (UILabel *)hintLab {
    if (!_hintLab) {
        _hintLab = [[UILabel alloc] init];
        _hintLab.text = @"主/客";
        _hintLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _hintLab.textColor = rgb(149, 157, 176);
    }
    return _hintLab;
}

- (UILabel *)team1Lab {
    if (!_team1Lab) {
        _team1Lab = [[UILabel alloc] init];
        _team1Lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _team1Lab.textColor = rgb(74, 74, 74);
    }
    return _team1Lab;
}

- (UILabel *)team2Lab {
    if (!_team2Lab) {
        _team2Lab = [[UILabel alloc] init];
        _team2Lab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _team2Lab.textColor = rgb(74, 74, 74);
    }
    return _team2Lab;
}

@end
