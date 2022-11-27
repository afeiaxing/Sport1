//
//  QYZYHistoryCell.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYHistoryCell.h"

@interface QYZYHistoryCell ()
@property (nonatomic, strong) UILabel *matchLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *hostNameLabel;
@property (nonatomic, strong) UILabel *hostCornerScoreLabel;
@property (nonatomic, strong) UIImageView *hostCornerIv;

@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *halfScoreLabel;

@property (nonatomic, strong) UILabel *awayNameLabel;
@property (nonatomic, strong) UILabel *awayCornerScoreLabel;
@property (nonatomic, strong) UIImageView *awayCornerIv;
@property (nonatomic, strong) UILabel *cornerLabel;
@end
@implementation QYZYHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSubview];
    }
    return self;
}

- (void)setModel:(QYZYMatchDetailModel *)model {
    if (model == nil) return;
    self.matchLabel.text = model.leagueName;
    self.timeLabel.text = [self getDateStringWithTimeStr:model.matchTime];
    self.hostNameLabel.text = model.hostTeamName;
    self.awayNameLabel.text = model.guestTeamName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@-%@",model.hostTeamScore,model.guestTeamScore];
    self.halfScoreLabel.text = [NSString stringWithFormat:@"(%@-%@)",model.hostHalfScore,model.guestHalfScore];
    self.hostCornerScoreLabel.text = model.hostCorner.length > 0 ? model.hostCorner : @"0";
    self.awayCornerScoreLabel.text = model.guestCorner.length > 0 ? model.guestCorner : @"0";
    if ([model.sportId isEqualToString:@"1"]) {
        self.cornerLabel.text = [NSString stringWithFormat:@"%d",model.hostCorner.intValue + model.guestCorner.intValue];
    }else {
        self.cornerLabel.text = model.dxRate.length > 0 ? model.dxRate : @"-";
    }
    
    CGSize size = CGSizeMake(100, MAXFLOAT);
    CGRect rect = [self.scoreLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]} context:nil];
    
    CGRect recthalf = [self.halfScoreLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]} context:nil];

    [self.scoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(rect.size.width + 10);
    }];
    
    [self.halfScoreLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(recthalf.size.width + 10);
    }];
    
    self.hostCornerScoreLabel.hidden = ![model.sportId isEqualToString:@"1"];
    self.awayCornerScoreLabel.hidden = ![model.sportId isEqualToString:@"1"];
    self.awayCornerIv.hidden = ![model.sportId isEqualToString:@"1"];
    self.hostCornerIv.hidden = ![model.sportId isEqualToString:@"1"];
}

// 时间戳转时间,时间戳为13位是精确到毫秒的，10位精确到秒
- (NSString *)getDateStringWithTimeStr:(NSString *)str {
    NSTimeInterval time = [str doubleValue] / 1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yy/MM/dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}

- (void)setSubview {
    [self.contentView addSubview:self.matchLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.contentView addSubview:self.hostNameLabel];
    [self.contentView addSubview:self.hostCornerScoreLabel];
    [self.contentView addSubview:self.hostCornerIv];
    
    [self.contentView addSubview:self.scoreLabel];
    [self.contentView addSubview:self.halfScoreLabel];
    
    [self.contentView addSubview:self.awayNameLabel];
    [self.contentView addSubview:self.awayCornerScoreLabel];
    [self.contentView addSubview:self.awayCornerIv];
    
    [self.contentView addSubview:self.cornerLabel];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(32);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.halfScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-6);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(32);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.matchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7);
        make.left.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(64, 16));
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-6);
        make.left.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(64, 16));
    }];
    
    [self.hostNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.matchLabel.mas_right);
        make.right.equalTo(self.scoreLabel.mas_left).offset(-6);
        make.height.mas_equalTo(16);
    }];
    
    [self.hostCornerIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hostNameLabel.mas_right);
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.bottom.mas_equalTo(-6);
    }];
    
    [self.hostCornerScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hostCornerIv.mas_left).offset(-6);
        make.centerY.equalTo(self.hostCornerIv);
        make.left.equalTo(self.hostNameLabel.mas_left);
        make.height.mas_equalTo(14);
    }];

    [self.cornerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(46, 16));
    }];

    [self.awayNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.scoreLabel.mas_right).offset(6);
        make.right.equalTo(self.cornerLabel.mas_left);
        make.height.mas_equalTo(16);
    }];
    
    [self.awayCornerIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awayNameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(8, 8));
        make.bottom.mas_equalTo(-6);
    }];
    
    [self.awayCornerScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.awayCornerIv.mas_right).offset(6);
        make.centerY.equalTo(self.awayCornerIv);
        make.height.mas_equalTo(14);
    }];
    
}

- (UILabel *)matchLabel {
    if (!_matchLabel) {
        _matchLabel = [[UILabel alloc] init];
        _matchLabel.textColor = rgb(51, 51, 51);
        _matchLabel.text = @"西甲";
        _matchLabel.font = [UIFont systemFontOfSize:10];
        _matchLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _matchLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = rgb(149, 157, 176);
        _timeLabel.text = @"20/10/22";
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}


- (UILabel *)hostNameLabel {
    if (!_hostNameLabel) {
        _hostNameLabel = [[UILabel alloc] init];
        _hostNameLabel.textColor = rgb(51, 51, 51);
        _hostNameLabel.text = @"曼联";
        _hostNameLabel.textAlignment = NSTextAlignmentRight;
        _hostNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _hostNameLabel;
}

- (UILabel *)hostCornerScoreLabel {
    if (!_hostCornerScoreLabel) {
        _hostCornerScoreLabel = [[UILabel alloc] init];
        _hostCornerScoreLabel.textColor = rgb(149, 157, 176);
        _hostCornerScoreLabel.text = @"8";
        _hostCornerScoreLabel.textAlignment = NSTextAlignmentRight;
        _hostCornerScoreLabel.font = [UIFont systemFontOfSize:10];
    }
    return _hostCornerScoreLabel;
}

- (UIImageView *)hostCornerIv {
    if (!_hostCornerIv) {
        _hostCornerIv = [[UIImageView alloc] init];
        _hostCornerIv.image = [UIImage imageNamed:@"match_detail_analyze_corner"];
    }
    return _hostCornerIv;
}


- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = rgb(255, 5, 5);
        _scoreLabel.text = @"1-1";
        _scoreLabel.font = [UIFont systemFontOfSize:10];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLabel;
}

- (UILabel *)halfScoreLabel {
    if (!_halfScoreLabel) {
        _halfScoreLabel = [[UILabel alloc] init];
        _halfScoreLabel.textColor = rgb(149, 157, 176);
        _halfScoreLabel.text = @"(0-0)";
        _halfScoreLabel.font = [UIFont systemFontOfSize:10];
        _halfScoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _halfScoreLabel;
}

- (UILabel *)awayNameLabel {
    if (!_awayNameLabel) {
        _awayNameLabel = [[UILabel alloc] init];
        _awayNameLabel.textColor = rgb(51, 51, 51);
        _awayNameLabel.text = @"切尔西";
        _awayNameLabel.font = [UIFont systemFontOfSize:10];
    }
    return _awayNameLabel;
}

- (UILabel *)awayCornerScoreLabel {
    if (!_awayCornerScoreLabel) {
        _awayCornerScoreLabel = [[UILabel alloc] init];
        _awayCornerScoreLabel.textColor = rgb(149, 157, 176);
        _awayCornerScoreLabel.text = @"8";
        _awayCornerScoreLabel.font = [UIFont systemFontOfSize:10];
    }
    return _awayCornerScoreLabel;
}

- (UIImageView *)awayCornerIv {
    if (!_awayCornerIv) {
        _awayCornerIv = [[UIImageView alloc] init];
        _awayCornerIv.image = [UIImage imageNamed:@"match_detail_analyze_corner"];
    }
    return _awayCornerIv;
}

- (UILabel *)cornerLabel {
    if (!_cornerLabel) {
        _cornerLabel = [[UILabel alloc] init];
        _cornerLabel.textColor = rgb(51, 51, 51);
        _cornerLabel.text = @"13";
        _cornerLabel.font = [UIFont systemFontOfSize:10];
        _cornerLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cornerLabel;
}
@end
