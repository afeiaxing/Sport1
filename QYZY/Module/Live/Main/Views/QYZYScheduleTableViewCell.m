//
//  QYZYScheduleTableViewCell.m
//  QYZY
//
//  Created by jspatches on 2022/9/29.
//

#import "QYZYScheduleTableViewCell.h"
#import "QYZYPhoneLoginViewController.h"

@implementation QYZYScheduleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addConstraintsAndActions];
        [self setcolors];
        self.backgroundColor = rgb(247, 248, 254);
    }
    return self;
}


- (void)myreserDataUI:(QYZYMyreserModel *)model
{
    self.homeTeamName.text = model.hostTeamName;
    self.visitingTeamName.text = model.guestTeamName;
    self.hometeamscores.text = [NSString stringWithFormat:@"%ld",(long)model.hostTeamScore];
    self.visitingteamscored.text = [NSString stringWithFormat:@"%ld",(long)model.guestTeamScore];
    self.league.text = model.leagueName;
    [self.hometeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hostTeamLogo] placeholderImage:QYZY_DEFAULT_AVATAR];
    [self.visitorImageView sd_setImageWithURL:[NSURL URLWithString:model.guestTeamLogo] placeholderImage:QYZY_DEFAULT_AVATAR];
    
    /// 比赛状态， // 1 未开始 2 进行中 3 已结束 4 已取消
    if (model.status == 1) {
        self.state.text = [self time_timestampToString:[model.matchTime integerValue]];
        self.state.textColor = rgb(149, 157, 176);
        self.hometeamscores.text = @"-";
         self.visitingteamscored.text = @"-";
        self.vs.text = @"VS";
        
        if (model.userIsAppointment == YES) {
            NSLog(@"已预约");
            self.appointmentButton.backgroundColor = [UIColor whiteColor];
            [self.appointmentButton setTitle:@"已预约" forState:UIControlStateNormal];
            [self.appointmentButton setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
            self.appointmentButton.layer.borderColor= rgb(41, 69, 192).CGColor;  //边框的颜色
            self.appointmentButton.layer.borderWidth = 1; //边框的宽度
            self.appointmentButton.layer.masksToBounds = YES;
            self.appointmentButton.layer.cornerRadius = 12;
        }
        else
        {
            [self.appointmentButton setTitle:@"预约" forState:UIControlStateNormal];
            [self.appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.appointmentButton.backgroundColor = rgb(41, 69, 192);
            
        }
        
        
    }
    else if (model.status == 2)
    {
        self.state.text = @"进行中";
        self.state.textColor = rgb(246, 83, 72);
        self.vs.text = @"-";
        
        [self.appointmentButton setTitle:@"已开赛" forState:UIControlStateNormal];
        [self.appointmentButton setTitleColor:rgb(97, 112, 152) forState:UIControlStateNormal];
        self.appointmentButton.backgroundColor = rgb(224, 228, 249);
        self.appointmentButton.userInteractionEnabled = NO;
        
    }
    else if (model.status == 3)
    {
        self.state.text = @"已结束";
        self.vs.text = @"-";
        
        [self.appointmentButton setTitle:@"已结束" forState:UIControlStateNormal];
        [self.appointmentButton setTitleColor:rgb(97, 112, 152) forState:UIControlStateNormal];
        self.appointmentButton.backgroundColor = rgb(224, 228, 249);
        self.appointmentButton.userInteractionEnabled = NO;
    }
    else if (model.status == 4)
    {
        self.state.text = @"已取消";
        self.vs.text = @"VS";
        [self.appointmentButton setTitle:@"已取消" forState:UIControlStateNormal];
        [self.appointmentButton setTitleColor:rgb(97, 112, 152) forState:UIControlStateNormal];
        self.appointmentButton.backgroundColor = rgb(224, 228, 249);
        self.appointmentButton.userInteractionEnabled = NO;
    }
    
}


- (void)updataUI:(QYZYMatchListInfoDetailModel *)model
{
    self.homeTeamName.text = model.hostTeamName;
    self.visitingTeamName.text = model.guestTeamName;
    self.hometeamscores.text = model.hostTeamScore;
    self.visitingteamscored.text = model.guestTeamScore;
    self.league.text = model.leagueName;
    [self.hometeamImageView sd_setImageWithURL:[NSURL URLWithString:model.hostTeamLogo] placeholderImage:QYZY_DEFAULT_AVATAR];
    [self.visitorImageView sd_setImageWithURL:[NSURL URLWithString:model.guestTeamLogo] placeholderImage:QYZY_DEFAULT_AVATAR];
    
    
    /// 比赛状态，1未开始，2进行中，3已结束，4已取消（status）
    if ([model.status isEqualToString:@"1"]) {
        self.state.text = [self time_timestampToString:[model.matchTime integerValue]];
        self.state.textColor = rgb(149, 157, 176);
        self.hometeamscores.text = @"-";
         self.visitingteamscored.text = @"-";
        self.vs.text = @"VS";
        
        if (model.userIsAppointment == YES) {
            NSLog(@"已预约");
            self.appointmentButton.backgroundColor = [UIColor whiteColor];
            [self.appointmentButton setTitle:@"已预约" forState:UIControlStateNormal];
            [self.appointmentButton setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
            self.appointmentButton.layer.borderColor= rgb(41, 69, 192).CGColor;  //边框的颜色
            self.appointmentButton.layer.borderWidth = 1; //边框的宽度
            self.appointmentButton.layer.masksToBounds = YES;
            self.appointmentButton.layer.cornerRadius = 12;
        }
        else
        {
            [self.appointmentButton setTitle:@"预约" forState:UIControlStateNormal];
            [self.appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.appointmentButton.backgroundColor = rgb(41, 69, 192);
            
        }
        
        
    }
    else if ([model.status isEqualToString:@"2"])
    {
        self.state.text = @"进行中";
        self.state.textColor = rgb(246, 83, 72);
        self.vs.text = @"-";
        
        [self.appointmentButton setTitle:@"已开赛" forState:UIControlStateNormal];
        [self.appointmentButton setTitleColor:rgb(97, 112, 152) forState:UIControlStateNormal];
        self.appointmentButton.backgroundColor = rgb(224, 228, 249);
        self.appointmentButton.userInteractionEnabled = NO;
        
    }
    else if ([model.status isEqualToString:@"3"])
    {
        self.state.text = @"已结束";
        self.vs.text = @"-";
        
        [self.appointmentButton setTitle:@"已结束" forState:UIControlStateNormal];
        [self.appointmentButton setTitleColor:rgb(97, 112, 152) forState:UIControlStateNormal];
        self.appointmentButton.backgroundColor = rgb(224, 228, 249);
        self.appointmentButton.userInteractionEnabled = NO;
    }
    else if ([model.status isEqualToString:@"4"])
    {
        self.state.text = @"已取消";
        self.vs.text = @"VS";
        [self.appointmentButton setTitle:@"已取消" forState:UIControlStateNormal];
        [self.appointmentButton setTitleColor:rgb(97, 112, 152) forState:UIControlStateNormal];
        self.appointmentButton.backgroundColor = rgb(224, 228, 249);
        self.appointmentButton.userInteractionEnabled = NO;
    }
    

    
}
#pragma mark - layout
- (void)addConstraintsAndActions
{
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.league];
    [self.backView addSubview:self.state];
    [self.backView addSubview:self.hometeamImageView];
    [self.backView addSubview:self.visitorImageView];
    [self.backView addSubview:self.homeTeamName];
    [self.backView addSubview:self.hometeamscores];
    [self.backView addSubview:self.visitingTeamName];
    [self.backView addSubview:self.visitingteamscored];
    [self.backView addSubview:self.vs];
    [self.backView addSubview:self.appointmentButton];
    
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(101);
        make.top.mas_equalTo(1);
    }];
    
    [self.league mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.top.mas_equalTo(7);
    }];
    
    [self.state mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(7);
    }];
    
    
    [self.vs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.hometeamscores mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vs.mas_left).mas_offset(-4);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.visitingteamscored mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vs.mas_right).mas_offset(4);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.hometeamImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.hometeamscores.mas_left).mas_offset(-4);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.visitorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.visitingteamscored.mas_right).mas_offset(4);
        make.width.height.mas_equalTo(20);
    }];
    
    [self.homeTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.equalTo(self.hometeamImageView.mas_left).mas_offset(-4);
    }];
    
    [self.visitingTeamName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.equalTo(self.visitorImageView.mas_right).mas_offset(4);
    
    }];
    
    [self.appointmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(24);
        make.bottom.mas_equalTo(-6);
    }];
    
}

- (void)Click:(UIButton *)button
{
    if (QYZYUserManager.shareInstance.isLogin == false) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [UIViewController.currentViewController presentViewController:vc animated:true completion:nil];
        });
        return;
    }
    !self.actionBlock ?: self.actionBlock();

}

- (void)setcolors
{
    _league.textColor = rgb(225, 89, 255);
    _homeTeamName.textColor = rgb(41, 69, 192);
    _visitingTeamName.textColor = _homeTeamName.textColor;
    _vs.textColor = _homeTeamName.textColor;
    _hometeamscores.textColor = UIColor.blackColor;
    _visitingteamscored.textColor = UIColor.blackColor;
    
}

#pragma mark - creatUI lazy

- (UIButton *)appointmentButton
{
    if (!_appointmentButton) {
        _appointmentButton = [[UIButton alloc]init];
        [_appointmentButton setTitle:@"预约" forState:UIControlStateNormal];
        [_appointmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _appointmentButton.layer.cornerRadius = 12;
        _appointmentButton.layer.masksToBounds = YES;
        _appointmentButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_appointmentButton addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appointmentButton;
}


- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColor.whiteColor;
        //设置阴影颜色
        _backView.layer.shadowColor = [UIColor colorWithRed:105.0/255.0 green:118.0/255.0 blue:157.0/255.0 alpha:1].CGColor;
          //设置阴影的透明度
        _backView.layer.shadowOpacity = 1;
          //设置阴影的偏移
        _backView.layer.shadowOffset = CGSizeMake(30.0f, 10.0f);
          //设置阴影半径
        _backView.layer.shadowRadius = 15.0f;
          //设置渲染内容被缓存
        _backView.layer.shouldRasterize = YES;
          //超出父视图部分是否显示
        _backView.layer.masksToBounds = NO;
          
        _backView.layer.borderWidth  = 0.0;
          
        _backView.layer.opaque = 0.10;
          
        _backView.layer.cornerRadius = 50.0;
          //栅格化处理
        _backView.layer.rasterizationScale = [[UIScreen mainScreen]scale];
          //正常矩形
          UIBezierPath *path = [UIBezierPath bezierPathWithRect:_backView.bounds];
        _backView.layer.shadowPath = path.CGPath;
    }
    return _backView;
}

- (UILabel *)league
{
    if (!_league) {
        _league = [[UILabel alloc]init];
        _league.font = [UIFont systemFontOfSize:11];
        _league.text = @"巴西甲";
    }
    return _league;
}

- (UILabel *)state
{
    if (!_state) {
        _state = [[UILabel alloc]init];
        _state.font = [UIFont systemFontOfSize:11];
        _state.text = @"进行中";
    }
    return _state;
}



- (UILabel *)homeTeamName
{
    if (!_homeTeamName) {
        _homeTeamName = [[UILabel alloc]init];
        _homeTeamName.font = [UIFont systemFontOfSize:13];
        _homeTeamName.text = @"皇家马德里";
    }
    return _homeTeamName;
}

- (UILabel *)visitingTeamName
{
    if (!_visitingTeamName) {
        _visitingTeamName = [[UILabel alloc]init];
        _visitingTeamName.font = [UIFont systemFontOfSize:13];
        _visitingTeamName.text = @"巴塞罗那";
    }
    return _visitingTeamName;
}

- (UILabel *)hometeamscores
{
    if (!_hometeamscores) {
        _hometeamscores = [[UILabel alloc]init];
        _hometeamscores.font = [UIFont systemFontOfSize:14];
        _hometeamscores.text = @"122";
    }
    return _hometeamscores;
}

- (UILabel *)vs
{
    if (!_vs) {
        _vs = [[UILabel alloc]init];
        _vs.font = [UIFont systemFontOfSize:14];
        _vs.text = @"VS";
    }
    return _vs;
}

- (UILabel *)visitingteamscored
{
    if (!_visitingteamscored) {
        _visitingteamscored = [[UILabel alloc]init];
        _visitingteamscored.font = [UIFont systemFontOfSize:14];
        _visitingteamscored.text = @"119";
    }
    return _visitingteamscored;
}

- (UIImageView *)hometeamImageView
{
    if (!_hometeamImageView) {
        _hometeamImageView = [[UIImageView alloc]init];
        
    }
    return _hometeamImageView;
}

- (UIImageView *)visitorImageView
{
    if (!_visitorImageView) {
        _visitorImageView = [[UIImageView alloc]init];
    }
    return _visitorImageView;
}


- (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];
    if (self.scheduleType == ScheduleTypeLiveDetailNotice) {
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}


@end
