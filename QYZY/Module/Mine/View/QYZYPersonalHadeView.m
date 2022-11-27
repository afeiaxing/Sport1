//
//  QYZYPersonalHadeView.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYPersonalHadeView.h"

@implementation QYZYPersonalHadeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addConstraintsAndActions];
    }
    return self;
}


- (void)updaFocus:(BOOL)isFocus
{
    if (isFocus == YES) {
        //关注
        [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_focusButton setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
        _focusButton.backgroundColor = rgb(255, 255, 255);
        _focusButton.layer.borderColor= rgb(149, 157, 176).CGColor;
        _focusButton.layer.borderWidth = 1;
    }
    else
    {
        //取消关注
        [_focusButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_focusButton setTitleColor:rgb(255, 255, 255) forState:UIControlStateNormal];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _focusButton.backgroundColor = rgb(41, 69, 192);
        
    }
}

- (void)updataUI:(QYZYMineModel *)model
{
    self.namelabel.text = model.nickname;
    self.signature.text = model.personalDesc;
    self.numberfans.text = [NSString stringWithFormat:@"%ld",(long)model.fansCount];
    self.numberfocus.text = [NSString stringWithFormat:@"%ld",(long)model.focusCount];
    [self.hadeImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
    
    if (model.isAnchor) {
        self.livstudioButton.alpha = 1;
    } else {
        self.livstudioButton.alpha = 0;
    }
    
    if ([model.userId intValue] == [[QYZYUserManager shareInstance].userModel.uid intValue]) {
        NSLog(@"是自己");
        self.focusButton.alpha = 0;
    }
    else
    {
        self.focusButton.alpha = 1;
        
        if (model.isAttention == YES) {
          
            [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
            [_focusButton setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
            _focusButton.backgroundColor = rgb(255, 255, 255);
            _focusButton.layer.borderColor= rgb(149, 157, 176).CGColor;
            _focusButton.layer.borderWidth = 1;
        }
        else
        {
           
            [_focusButton setTitle:@"+ 关注" forState:UIControlStateNormal];
            [_focusButton setTitleColor:rgb(255, 255, 255) forState:UIControlStateNormal];
            _focusButton.titleLabel.font = [UIFont systemFontOfSize:12];
            _focusButton.backgroundColor = rgb(41, 69, 192);
            
        }
//        if (model.isFans == YES) {
//            NSLog(@"是粉丝");
//        }
//        else
//        {
//            NSLog(@"不是粉丝");
//        }
    }
}

- (void)addConstraintsAndActions
{
    [self addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.top.mas_equalTo(9+StatusBarHeight);
        make.width.height.mas_equalTo(28);
    }];
    
    
    [self addSubview:self.fanslabel];
    [self.fanslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-21);
        make.top.mas_equalTo(77);
    }];

    
    [self addSubview:self.numberfans];
    [self.numberfans mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.fanslabel.mas_centerX).offset(0);
        make.bottom.mas_equalTo(self.fanslabel.mas_top).offset(-4);
        
    }];
    
    
    [self addSubview:self.focuslabel];
    [self.focuslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fanslabel.mas_left).offset(-44);
        make.top.mas_equalTo(77);
    }];
    
    [self addSubview:self.numberfocus];
    [self.numberfocus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.focuslabel.mas_centerX).offset(0);
        make.bottom.mas_equalTo(self.focuslabel.mas_top).offset(-4);
        
    }];
    
    
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.fanslabel.mas_left).offset(-20);
        make.top.mas_equalTo(59);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(32);
    }];
    
    
    [self addSubview:self.hadeBackView];
    [self.hadeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.fanslabel.mas_bottom).offset(12);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(110);
    }];
    
    [self.hadeBackView addSubview:self.hadeImageView];
    [self.hadeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(23);
        make.width.height.mas_equalTo(64);
    }];
    
    [self.hadeBackView addSubview:self.namelabel];
    [self.namelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hadeImageView.mas_right).offset(8);
        make.top.mas_equalTo(24);
    }];
    
    [self.hadeBackView addSubview:self.signature];
    [self.signature mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hadeImageView.mas_right).offset(8);
        make.top.mas_equalTo(self.namelabel.mas_bottom).offset(2);
    }];
    
    [self.hadeBackView addSubview:self.livstudioButton];
    self.livstudioButton.alpha = 0;
    [self.livstudioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hadeImageView.mas_right).offset(8);
        make.top.mas_equalTo(self.signature.mas_bottom).offset(7);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(24);
    }];
    
    [self.hadeBackView addSubview:self.focusButton];
    self.focusButton.alpha = 0;
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.livstudioButton.mas_right).offset(8);
        make.top.mas_equalTo(self.signature.mas_bottom).offset(7);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(24);
    }];

    [self.hadeBackView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(8);
    }];
    
    
}


- (UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@"bgMeQianbao"];
    }
    return _backImageView;
}

- (UILabel *)fanslabel
{
    if (!_fanslabel) {
        _fanslabel = [[UILabel alloc]init];
        _fanslabel.text = @"粉丝";
        _fanslabel.textColor = rgba(255, 255, 255, 0.8);
        _fanslabel.font = [UIFont systemFontOfSize:12];
    }
    return _fanslabel;
}

- (UILabel *)focuslabel
{
    if (!_focuslabel) {
        _focuslabel = [[UILabel alloc]init];
        _focuslabel.text = @"关注";
        _focuslabel.textColor = rgba(255, 255, 255, 0.8);
        _focuslabel.font = [UIFont systemFontOfSize:12];
    }
    return _focuslabel;
}

- (UILabel *)numberfans
{
    if (!_numberfans) {
        _numberfans = [[UILabel alloc]init];
        _numberfans.text = @"0";
        _numberfans.textColor = rgb(255, 255, 255);
        _numberfans.font = [UIFont systemFontOfSize:14];
    }
    return _numberfans;
}

- (UILabel *)numberfocus
{
    if (!_numberfocus) {
        _numberfocus = [[UILabel alloc]init];
        _numberfocus.text = @"0";
        _numberfocus.textColor = rgb(255, 255, 255);
        _numberfocus.font = [UIFont systemFontOfSize:14];
    }
    return _numberfocus;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = rgb(229, 229, 234);
    }
    return _lineView;
}


- (UIView *)hadeBackView
{
    if (!_hadeBackView) {
        _hadeBackView = [[UIView alloc]init];
        
        _hadeBackView.backgroundColor = [UIColor whiteColor];
    }
    return _hadeBackView;
}

- (UIImageView *)hadeImageView
{
    if (!_hadeImageView) {
        _hadeImageView = [[UIImageView alloc]init];
        _hadeImageView.backgroundColor = [UIColor whiteColor];
        _hadeImageView.userInteractionEnabled = YES;
        _hadeImageView.layer.cornerRadius = 32.0;
        _hadeImageView.layer.masksToBounds = YES;
        _hadeImageView.image = [UIImage imageNamed:@"imgTouxiang1"];
    }
    return _hadeImageView;
}

- (UILabel *)namelabel
{
    if (!_namelabel) {
        _namelabel = [[UILabel alloc]init];
        _namelabel.text = @"用户name";
        _namelabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _namelabel.textColor = rgb(34, 0, 0);
        _namelabel.userInteractionEnabled = YES;
       
        
    }
    return _namelabel;
}

- (UILabel *)signature
{
    if (!_signature) {
        _signature = [[UILabel alloc]init];
        _signature.text = @"个性签名个性签名个性签名个性签名个性签名";
        _signature.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
        _signature.textColor =  rgb(149, 157, 176);
    }
    return _signature;
}

- (UIButton *)livstudioButton
{
    if (!_livstudioButton) {
        _livstudioButton = [[UIButton alloc]init];
        [_livstudioButton setTitle:@"Ta的直播间" forState:UIControlStateNormal];
        [_livstudioButton setTitleColor:rgb(255, 255, 255) forState:UIControlStateNormal];
        _livstudioButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _livstudioButton.layer.masksToBounds = YES;
        _livstudioButton.layer.cornerRadius = 12;
        _livstudioButton.backgroundColor = rgb(255, 71, 115);
    }
    
    return _livstudioButton;
}

- (UIButton *)focusButton
{
    if (!_focusButton) {
        _focusButton = [[UIButton alloc]init];
        [_focusButton setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_focusButton setTitleColor:rgb(255, 255, 255) forState:UIControlStateNormal];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _focusButton.layer.masksToBounds = YES;
        _focusButton.layer.cornerRadius = 12;
        _focusButton.backgroundColor = rgb(41, 69, 192);
    }
    
    return _focusButton;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = rgb(247, 248, 254);
    }
    return _bottomView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton new];
        [_backButton setImage:[UIImage imageNamed:@"iconBai"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


- (void)backClick
{
    if (self.backBlock) {
        self.backBlock();
    }
}



@end
