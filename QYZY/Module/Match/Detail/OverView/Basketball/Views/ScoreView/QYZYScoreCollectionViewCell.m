//
//  QYZYScoreCollectionViewCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYScoreCollectionViewCell.h"

@interface QYZYScoreCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UILabel *team1Label;

@property (nonatomic, strong) UILabel *team2Label;

@property (nonatomic, strong) UIImageView *team1ImgView;

@property (nonatomic, strong) UIImageView *team2ImgView;

@property (nonatomic, strong) NSArray *team1Datas;

@property (nonatomic, strong) NSArray *team2Datas;

@property (nonatomic, strong) UILabel *team1NameLab;

@property (nonatomic, strong) UILabel *team2NameLab;

@end

@implementation QYZYScoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = @[@"  赛况比分",@"一",@"二",@"三",@"四",@"总分"];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.team1Label];
    [self.contentView addSubview:self.team2Label];
    [self.contentView addSubview:self.team1ImgView];
    [self.contentView addSubview:self.team2ImgView];
    [self.contentView addSubview:self.team1NameLab];
    [self.contentView addSubview:self.team2NameLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_offset(32);
    }];
    
    UILabel *topLine = [[UILabel alloc] init];
    topLine.backgroundColor = rgba(229, 229, 234, 0.3);
    [self.contentView addSubview:topLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.height.mas_offset(0.5);
        make.top.equalTo(self.contentView).offset(32);
    }];
    
    CGFloat width = (ScreenWidth - 133)/5.0;
    [self.team1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(24);
        make.width.mas_offset(width);
    }];
    
    [self.team2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.team1Label.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_offset(24);
        make.width.mas_offset(width);
    }];
    
    [self.team1ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(20);
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(topLine.mas_bottom).offset(2);
    }];
    
    [self.team2ImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(20);
        make.left.equalTo(self.contentView).offset(12);
        make.top.equalTo(self.team1ImgView.mas_bottom).offset(4);
    }];
    
    [self.team1NameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(24);
        make.left.equalTo(self.team1ImgView.mas_right).offset(3);
        make.right.equalTo(self.contentView).offset(-4);
        make.centerY.equalTo(self.team1ImgView);
    }];
    
    [self.team2NameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(24);
        make.left.equalTo(self.team2ImgView.mas_right).offset(3);
        make.right.equalTo(self.contentView).offset(-4);
        make.centerY.equalTo(self.team2ImgView);
    }];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (self.titleArray.count > indexPath.section) {
        NSString *title = self.titleArray[indexPath.section];
        if (indexPath.section == 0) {
            self.titleLab.text = title;
            self.titleLab.textAlignment = NSTextAlignmentLeft;
            self.team1ImgView.hidden = NO;
            self.team2ImgView.hidden = NO;
            self.team1NameLab.hidden = NO;
            self.team2NameLab.hidden = NO;
        }else {
            self.titleLab.text = title;
            self.titleLab.textAlignment = NSTextAlignmentCenter;
            self.team1ImgView.hidden = YES;
            self.team2ImgView.hidden = YES;
            self.team1NameLab.hidden = YES;
            self.team2NameLab.hidden = YES;
        }
        
        if (indexPath.section == self.titleArray.count - 1) {
            self.team1Label.textColor = rgb(255, 67, 67);
            self.team2Label.textColor = rgb(255, 67, 67);
        }else {
            self.team1Label.textColor = rgb(51, 51, 51);
            self.team2Label.textColor = rgb(51, 51, 51);
        }
    }
}

#pragma mark - getter
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = rgb(149, 157, 176);
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UILabel *)team1Label {
    if (!_team1Label) {
        _team1Label = [[UILabel alloc] init];
        _team1Label.text = @"-";
        _team1Label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _team1Label.textColor = rgb(51, 51, 51);
        _team1Label.textAlignment = NSTextAlignmentCenter;
    }
    return _team1Label;
}

- (UILabel *)team2Label {
    if (!_team2Label) {
        _team2Label = [[UILabel alloc] init];
        _team2Label.text = @"-";
        _team2Label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _team2Label.textColor = rgb(51, 51, 51);
        _team2Label.textAlignment = NSTextAlignmentCenter;
    }
    return _team2Label;
}

- (UIImageView *)team1ImgView {
    if (!_team1ImgView) {
        _team1ImgView = [[UIImageView alloc] init];
        _team1ImgView.hidden = YES;
        _team1ImgView.layer.masksToBounds = YES;
    }
    return _team1ImgView;
}

- (UIImageView *)team2ImgView {
    if (!_team2ImgView) {
        _team2ImgView = [[UIImageView alloc] init];
        _team2ImgView.hidden = YES;
        _team2ImgView.layer.masksToBounds = YES;
    }
    return _team2ImgView;
}

- (UILabel *)team1NameLab {
    if (!_team1NameLab) {
        _team1NameLab = [[UILabel alloc] init];
        _team1NameLab.text = @"-";
        _team1NameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _team1NameLab.textColor = rgb(51, 51, 51);
        _team1NameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _team1NameLab;
}

- (UILabel *)team2NameLab {
    if (!_team2NameLab) {
        _team2NameLab = [[UILabel alloc] init];
        _team2NameLab.text = @"-";
        _team2NameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _team2NameLab.textColor = rgb(51, 51, 51);
        _team2NameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _team2NameLab;
}

- (void)setPeriodModel:(QYZYPeriodModel *)periodModel {
    _periodModel = periodModel;
    if (periodModel) {
        self.team1Datas = @[@"",[self getData:periodModel.Period1.team1],[self getData:periodModel.Period2.team1],[self getData:periodModel.Period3.team1],[self getData:periodModel.Period4.team1],[self getData:periodModel.Current.team1]];
        self.team2Datas = @[@"",[self getData:periodModel.Period1.team2],[self getData:periodModel.Period2.team2],[self getData:periodModel.Period3.team2],[self getData:periodModel.Period4.team2],[self getData:periodModel.Current.team2]];
        self.team1Label.text = self.team1Datas[self.indexPath.section];
        self.team2Label.text = self.team2Datas[self.indexPath.section];
    }
}

- (void)setDetailModel:(QYZYMatchMainModel *)detailModel {
    _detailModel = detailModel;
    [self.team1ImgView sd_setImageWithURL:[NSURL URLWithString:detailModel.hostTeamLogo] placeholderImage:[UIImage imageNamed:@""]];
    [self.team2ImgView sd_setImageWithURL:[NSURL URLWithString:detailModel.guestTeamLogo] placeholderImage:[UIImage imageNamed:@""]];
    self.team1NameLab.text = detailModel.hostTeamName;
    self.team2NameLab.text = detailModel.guestTeamName;
}

- (NSString *)getData:(NSString *)data {
    NSString *callback = [NSString stringWithFormat:@"%@",data];
    if (callback.length == 0) {
        callback = @"-";
    }
    
    if (data == nil) {
        callback = @"-";
    }
    
    return callback;
}

@end
