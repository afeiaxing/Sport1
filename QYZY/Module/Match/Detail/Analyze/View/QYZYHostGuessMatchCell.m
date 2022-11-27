//
//  QYZYHostGuessMatchCell.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYHostGuessMatchCell.h"

@interface QYZYHostGuessMatchCell ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *matchLabel;

@property (nonatomic, strong) UIView *againstView;
@property (nonatomic, strong) UILabel *hostNameLabel;
@property (nonatomic, strong) UILabel *vsLabel;
@property (nonatomic, strong) UILabel *awayNameLabel;

@property (nonatomic, strong) UILabel *intervalLabel;
@end

@implementation QYZYHostGuessMatchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubview];
    }
    return self;
}

- (void)setSubview {
    [self addSubview:self.timeLabel];
    [self addSubview:self.matchLabel];
    [self addSubview:self.againstView];
    [self.againstView addSubview:self.vsLabel];
    [self.againstView addSubview:self.hostNameLabel];
    [self.againstView addSubview:self.awayNameLabel];
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
    
    [self.againstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.matchLabel.mas_right);
        make.width.mas_equalTo(2 * ScreenWidth / 5);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
    
    [self.vsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.againstView);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [self.hostNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.equalTo(self.againstView);
        make.right.equalTo(self.vsLabel.mas_left).offset(-10);
        make.height.mas_equalTo(14);
    }];
    
    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.againstView);
        make.left.equalTo(self.vsLabel.mas_right).offset(10);
        make.height.mas_equalTo(14);
    }];
    
    [self.intervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.againstView.mas_right);
        make.width.mas_equalTo(ScreenWidth / 5);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
    }];
}

- (void)setMainModel:(QYZYMatchMainModel *)mainModel {
    _mainModel = mainModel;
    self.timeLabel.text = [self time_timestampToString:mainModel.matchTime.integerValue];
    self.matchLabel.text = mainModel.leagueName;
    self.hostNameLabel.text = mainModel.hostTeamName.length >= 4 ? [mainModel.hostTeamName substringToIndex:4] : mainModel.hostTeamName;
    self.awayNameLabel.text = mainModel.guestTeamName.length >= 4 ? [mainModel.guestTeamName substringToIndex:4] : mainModel.guestTeamName;
    self.intervalLabel.text = [NSString stringWithFormat:@"%@天", mainModel.timeInterval];
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = rgb(149, 157, 176);
        _timeLabel.text = @"-";
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)matchLabel {
    if (!_matchLabel) {
        _matchLabel = [[UILabel alloc] init];
        _matchLabel.textColor = rgb(51, 51, 51);
        _matchLabel.text = @"-";
        _matchLabel.textAlignment = NSTextAlignmentCenter;
        _matchLabel.font = [UIFont systemFontOfSize:10];
    }
    return _matchLabel;
}


- (UIView *)againstView {
    if (!_againstView) {
        _againstView = [[UIView alloc] init];
    }
    return _againstView;
}

- (UILabel *)vsLabel {
    if (!_vsLabel) {
        _vsLabel = [[UILabel alloc] init];
        _vsLabel.textColor = rgb(149, 157, 176);
        _vsLabel.text = @"VS";
        _vsLabel.font = [UIFont systemFontOfSize:10];
        _vsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _vsLabel;
}

- (UILabel *)hostNameLabel {
    if (!_hostNameLabel) {
        _hostNameLabel = [[UILabel alloc] init];
        _hostNameLabel.textColor = rgb(149, 157, 176);
        _hostNameLabel.text = @"-";
        _hostNameLabel.font = [UIFont systemFontOfSize:10];
        _hostNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _hostNameLabel;
}

- (UILabel *)awayNameLabel {
    if (!_awayNameLabel) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.textColor = rgb(149, 157, 176);
        _awayNameLabel.text = @"-";
        _awayNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _awayNameLabel;
}

- (UILabel *)intervalLabel {
    if (!_intervalLabel) {
        _intervalLabel = [[UILabel alloc] init];
        _intervalLabel.textColor = rgb(149, 157, 176);
        _intervalLabel.text = @"-";
        _intervalLabel.font = [UIFont systemFontOfSize:10];
        _intervalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _intervalLabel;
}

#pragma mark - help
- (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}

@end
