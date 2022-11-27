//
//  QYZYTableHadeView.m
//  QYZY
//
//  Created by jspatches on 2022/10/2.
//

#import "QYZYTableHadeView.h"

@implementation QYZYTableHadeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addConstraintsAndActions];
    }
    return self;
}

- (void)exit
{
    self.namelabel.text = @"登录/注册";
    self.signature.text = @"";
    self.level.text = @"财富等级 0";
    self.fansLabelnumber.text = @"0";
    self.focusnumber.text  = @"0";
    self.hadeImageView.image = [UIImage imageNamed:@"imgTouxiang1"];
    self.beansLabel.text = @"0";
    
}


- (void)updataAmount:(QYZYAmountwithModel *)model
{
    self.beansLabel.text = [NSString stringWithFormat:@"%.2f",model.balance/100];
}

- (void)updataUI:(QYZYMineModel *)model
{
    self.namelabel.text = model.nickname;
    self.signature.text = model.personalDesc;
    self.level.text = [NSString stringWithFormat:@"财富等级 %@",model.wealthLevel];
    self.fansLabelnumber.text = [NSString stringWithFormat:@"%ld",(long)model.fansCount];
    self.focusnumber.text = [NSString stringWithFormat:@"%ld",(long)model.focusCount];
    [self.hadeImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
}


- (void)addConstraintsAndActions
{
    [self addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(196 + StatusBarHeight);
    }];
    
    [self.backImageView addSubview:self.setButton];
    [self.setButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(8+StatusBarHeight);
        make.width.height.mas_equalTo(28);
    }];
    
    
    [self.backImageView addSubview:self.hadeImageView];
    [self.hadeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(44 + StatusBarHeight);
        make.width.height.mas_equalTo(60);
    }];
    
    [self.backImageView addSubview:self.namelabel];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hadeImageView.mas_right).offset(11);
        make.top.mas_equalTo(54 + StatusBarHeight);
    }];
    
    [self.backImageView addSubview:self.signature];
    [self.signature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hadeImageView.mas_right).offset(11);
        make.top.mas_equalTo(self.namelabel.mas_bottom).offset(1);
    }];
    
    [self.backImageView addSubview:self.focusLabel];
    [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hadeImageView.mas_right).offset(9);
        make.top.mas_equalTo(self.signature.mas_bottom).offset(30);
    }];
    
    [self.backImageView addSubview:self.focusnumber];
    [self.focusnumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.focusLabel.mas_right).offset(6);
        make.top.mas_equalTo(self.signature.mas_bottom).offset(28);
    }];
    
    
    [self.backImageView addSubview:self.fansLabel];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.focusnumber.mas_right).offset(28);
        make.top.mas_equalTo(self.signature.mas_bottom).offset(30);
    }];
    
    [self.backImageView addSubview:self.fansLabelnumber];
    [self.fansLabelnumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.fansLabel.mas_right).offset(6);
        make.top.mas_equalTo(self.signature.mas_bottom).offset(28);
    }];
    
    
//    [self.backImageView addSubview:self.leveView];
//    [self.leveView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.top.mas_equalTo(self.fansLabelnumber.mas_bottom).offset(23);
//        make.right.mas_equalTo(self.mas_right).offset(-15);
//        make.height.mas_equalTo(40);
//    }];
    
    [self.backImageView addSubview:self.upView];
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(self.fansLabelnumber.mas_bottom).offset(23);
        make.width.mas_equalTo(166);
        make.height.mas_equalTo(40);
    }];
    self.upView.hidden = true;
//    [self.leveView addSubview:self.leveImageView];
//    [self.leveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-8);
//        make.centerY.mas_equalTo(0);
//        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
//    }];
    
    [self.upView addSubview:self.uplabel];
    [self.uplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    
    
    [self.leveView addSubview:self.level];
    [self.level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    
    [self.upView addSubview:self.upImageView];
    [self.upImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-8);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    

    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(self.focusLabel.mas_bottom).offset(20);
    }];
    [self.imageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.imageView).offset(12);
    }];
    
    [self.imageView addSubview:self.beansImageView];
    [self.beansImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView).offset(16);
        make.top.equalTo(self.imageView).offset(41);
    }];

    [self.imageView addSubview:self.beansLabel];
    [self.beansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.beansImageView.mas_right).offset(11);
        make.centerY.mas_equalTo(self.beansImageView);
    }];
    [self.imageView addSubview:self.chargeButton];
    [self.chargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(56, 24));
        make.right.equalTo(self.imageView).offset(-12);
        make.centerY.mas_equalTo(self.beansImageView);
    }];
    
    [self.backImageView addSubview:self.pushImageView];
    [self.pushImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(self.setButton.mas_bottom).offset(25);
        make.width.height.mas_equalTo(28);
    }];
    
}


-(void)tapClick:(UITapGestureRecognizer *)recognizer{
    
    if (self.actionBlock) {
        self.actionBlock();
    }

//    if (!_photoManager) {
//        _photoManager =[[QYZYPhotoManager alloc]init];
//    }
//    [_photoManager startSelectPhotoWithImageName:@"选择头像"];
//    __weak typeof(self)mySelf=self;
//    //选取照片成功
//    _photoManager.successHandle=^(QYZYPhotoManager *manager,UIImage *image){
//
//        mySelf.hadeImageView.image = image;
//        //保存到本地
//        NSData *data = UIImagePNGRepresentation(image);
//        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"headerImage"];
//    };
}


- (UIImageView *)hadeImageView
{
    if (!_hadeImageView) {
        _hadeImageView = [[UIImageView alloc]init];
        _hadeImageView.backgroundColor = [UIColor whiteColor];
        _hadeImageView.userInteractionEnabled = YES;
        _hadeImageView.layer.cornerRadius = 30.0;
        _hadeImageView.layer.masksToBounds = YES;
        _hadeImageView.image = [UIImage imageNamed:@"imgTouxiang1"];
    }
    return _hadeImageView;
}


- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"bgMe"];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (UILabel *)namelabel
{
    if (!_namelabel) {
        _namelabel = [[UILabel alloc]init];
        _namelabel.text = @"登录/注册";
        _namelabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _namelabel.textColor = rgb(255, 255, 255);
        _namelabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_namelabel addGestureRecognizer:tap];
        
    }
    return _namelabel;
}

- (UILabel *)signature
{
    if (!_signature) {
        _signature = [[UILabel alloc]init];
        _signature.text = @"";
        _signature.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
        _signature.textColor =  rgba(255, 255, 255, 0.5);
    }
    return _signature;
}




- (UILabel *)focusLabel
{
    if (!_focusLabel) {
        _focusLabel = [[UILabel alloc]init];
        _focusLabel.textColor = rgba(255, 255, 255,0.8);
        _focusLabel.text = @"关注";
        _focusLabel.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _focusLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upClick:)];
        [_focusLabel addGestureRecognizer:tap];
    }
    return _focusLabel;
}

- (UILabel *)fansLabel
{
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc]init];
        _fansLabel.textColor = rgba(255, 255, 255,0.8);
        _fansLabel.text = @"粉丝";
        _fansLabel.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
        _fansLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upClick:)];
        [_fansLabel addGestureRecognizer:tap];
    }
    return _fansLabel;
}

- (UILabel *)focusnumber
{
    if (!_focusnumber) {
        _focusnumber = [[UILabel alloc]init];
        _focusnumber.textColor = rgb(255, 255, 255);
        _focusnumber.text = @"0";
        _focusnumber.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _focusnumber.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upClick:)];
        [_focusnumber addGestureRecognizer:tap];
    }
    return _focusnumber;
}

- (UILabel *)fansLabelnumber
{
    if (!_fansLabelnumber) {
        _fansLabelnumber = [[UILabel alloc]init];
        _fansLabelnumber.textColor = rgb(255, 255, 255);
        _fansLabelnumber.text = @"0";
        _fansLabelnumber.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _fansLabelnumber.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upClick:)];
        [_fansLabelnumber addGestureRecognizer:tap];
    }
    return _fansLabelnumber;
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = UIColor.whiteColor;
        _imageView.layer.cornerRadius = 10;
        _imageView.layer.shadowColor = rgb(105, 106, 120).CGColor;
        _imageView.layer.shadowOffset = CGSizeMake(0, 3);
        _imageView.layer.shadowRadius = 10;
        _imageView.layer.shadowOpacity = 0.1;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topUpClick:)];
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"我的财富豆";
        _titleLabel.textColor = rgb(41, 69, 192);
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC" size:14];
    }
    return _titleLabel;
}

- (UIImageView *)beansImageView
{
    if (!_beansImageView) {
        _beansImageView = [[UIImageView alloc]init];
        _beansImageView.image = [UIImage imageNamed:@"iconMeQz"];
        _beansImageView.userInteractionEnabled = YES;
    }
    return _beansImageView;
}

- (UILabel *)beansLabel
{
    if (!_beansLabel) {
        _beansLabel = [[UILabel alloc]init];
        _beansLabel.textColor = rgb(41, 69, 192);
        _beansLabel.text = @"0";
        _beansLabel.font =  [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
    }
    return _beansLabel;
}

- (UIButton *)chargeButton {
    if (!_chargeButton) {
        _chargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chargeButton setTitle:@"充值" forState:UIControlStateNormal];
        _chargeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _chargeButton.backgroundColor = rgb(41, 69, 192);
        _chargeButton.layer.cornerRadius = 12;
        _chargeButton.layer.masksToBounds = YES;
        _chargeButton.userInteractionEnabled = NO;
    }
    return _chargeButton;
}

- (UIButton *)setButton
{
    if (!_setButton) {
        _setButton = [[UIButton  alloc]init];
        [_setButton setImage:[UIImage imageNamed:@"iconShezhi"] forState:UIControlStateNormal];
        [_setButton addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setButton;
}


- (UILabel *)level
{
    if (!_level) {
        _level = [[UILabel alloc]init];
        _level.textColor = rgb(117, 71, 25);
        _level.text = @"财富等级0";
        _level.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
        [_level setTextAlignment:NSTextAlignmentCenter];
    }
    return _level;
}

- (UIView *)leveView
{
    if (!_leveView) {
        _leveView = [[UIView alloc]init];
        _leveView.backgroundColor = rgb(255, 248, 196);
        _leveView.layer.cornerRadius = 8.0;
        _leveView.layer.masksToBounds = YES;
    }
    return _leveView;
}

- (UIView *)upView
{
    if (!_upView) {
        _upView = [[UIView alloc]init];
        _upView.backgroundColor = rgb(252, 228, 255);
        _upView.layer.cornerRadius = 8.0;
        _upView.layer.masksToBounds = YES;
        _upView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topUpClick:)];
        [_upView addGestureRecognizer:tap];
    }
    return _upView;
}

- (UILabel *)uplabel
{
    if (!_uplabel) {
        _uplabel = [[UILabel alloc]init];
        _uplabel.textColor = rgb(153, 37, 145);
        _uplabel.text = @"充值";
        _uplabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
        [_uplabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _uplabel;
}

- (UIImageView *)leveImageView
{
    if (!_leveImageView) {
        _leveImageView = [[UIImageView alloc]init];
        _leveImageView.image = [UIImage imageNamed:@"icon_2"];
        
    }
    return _leveImageView;
}

- (UIImageView *)upImageView
{
    if (!_upImageView) {
        _upImageView = [[UIImageView alloc]init];
        _upImageView.image = [UIImage imageNamed:@"icon"];
        
    }
    return _upImageView;
}

- (UIButton *)pushImageView
{
    if (!_pushImageView) {
        _pushImageView = [[UIButton alloc]init];
        [_pushImageView setImage:[UIImage imageNamed:@"icon_1"] forState:UIControlStateNormal];
        [_pushImageView addTarget:self action:@selector(pushClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushImageView;
}

- (void)pushClick:(UIButton *)button
{
    if (self.pushBlock) {
        self.pushBlock();
    }
}

- (void)topUpClick:(UITapGestureRecognizer *)tap
{
    if (self.topupBlock) {
        self.topupBlock();
    }
}

- (void)upClick:(UITapGestureRecognizer *)tap
{
    if (self.upBlock) {
        self.upBlock();
    }
}

- (void)setClick:(UIButton *)button
{
    if (self.setupBlock) {
        self.setupBlock();
    }
    
}

@end
