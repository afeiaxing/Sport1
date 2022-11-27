//
//  QYZYMyattentionTableViewCell.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYMyattentionTableViewCell.h"
#import "QYZYPhoneLoginViewController.h"

@implementation QYZYMyattentionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addConstraintsAndActions];
        self.backgroundColor = rgb(247, 248, 254);
    }
    return self;
}


- (void)updataUI:(QYZYMyattentionModel *)model
{
    NSLog(@"%@",model);
    self.model = model;
    self.nameLabel.text = model.nickname;
    self.fansLabel.text = [NSString stringWithFormat:@"粉丝数 %@",model.fansCount];
    [self.hadeImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
    [self.liveImageView sd_setImageWithURL:[NSURL URLWithString:model.levelImg]];

    if (model.isAttention == YES) {
        [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
        self.focusButton.backgroundColor = UIColor.clearColor;
        self.focusButton.layer.borderWidth = 1;
    }
    else {
        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.focusButton.backgroundColor = rgb(41, 69, 192);
        self.focusButton.layer.borderWidth = 0;
    }
}

- (void)focusAction {
    if (!QYZYUserManager.shareInstance.isLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [UIViewController.currentViewController presentViewController:vc animated:true completion:nil];
        });
        return;
    }
    !self.focusBlock ? : self.focusBlock(self.model);
}

- (void)addConstraintsAndActions
{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.backView addSubview:self.hadeImageView];
    [self.hadeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(38);
    }];
    
    
    [self.backView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hadeImageView.mas_right).mas_equalTo(6);
        make.top.mas_equalTo(18);
    }];
    
    [self.backView addSubview:self.fansLabel];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hadeImageView.mas_right).mas_equalTo(6);
        make.top.equalTo(self.nameLabel.mas_bottom).mas_equalTo(0);
    }];
    
    [self.backView addSubview:self.liveImageView];
    [self.liveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).mas_equalTo(5);
        make.top.mas_equalTo(16);
        make.width.mas_equalTo(46);
        make.height.mas_equalTo(20);
    }];
    
    [self.backView addSubview:self.focusButton];
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-14);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(64);
        make.height.mas_equalTo(24);
    }];
}

- (UIImageView *)hadeImageView
{
    if (!_hadeImageView) {
        _hadeImageView = [[UIImageView alloc]init];
        _hadeImageView.layer.cornerRadius = 19.0;
        _hadeImageView.layer.masksToBounds = YES;
    }
    return _hadeImageView;
}

- (UIImageView *)liveImageView
{
    if (!_liveImageView) {
        _liveImageView = [[UIImageView alloc]init];
    }
    return _liveImageView;
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.text = @"我司机一个用户";
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textColor = rgb(34, 34, 34);
    }
    return _nameLabel;
}

- (UILabel *)fansLabel
{
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc]init];
        _fansLabel.text = @"粉丝数 17.7w";
        _fansLabel.font = [UIFont systemFontOfSize:12];
        _fansLabel.textColor = rgb(149, 157, 176);
    }
    return _fansLabel;
}

- (UIButton *)focusButton
{
    if (!_focusButton) {
        _focusButton = [[UIButton alloc]init];
        [_focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [_focusButton setTitleColor:rgb(149 , 157, 176) forState:UIControlStateNormal];
        _focusButton.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        _focusButton.layer.borderColor= rgb(149, 157, 176).CGColor;  //边框的颜色
        _focusButton.layer.borderWidth = 1; //边框的宽度
        _focusButton.layer.masksToBounds = YES;
        _focusButton.layer.cornerRadius = 12;
        [_focusButton addTarget:self action:@selector(focusAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _focusButton;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = UIColor.whiteColor;
        _backView.layer.shadowColor = [UIColor colorWithRed:105.0/255.0 green:118.0/255.0 blue:157.0/255.0 alpha:1].CGColor;
        _backView.layer.shadowOpacity = 1;
        _backView.layer.shadowOffset = CGSizeMake(30.0f, 10.0f);
        _backView.layer.shadowRadius = 15.0f;
        _backView.layer.shouldRasterize = YES;
          //超出父视图部分是否显示
        _backView.layer.masksToBounds = NO;
          
        _backView.layer.borderWidth  = 0.0;
          
        _backView.layer.opaque = 0.10;
          
        _backView.layer.cornerRadius = 8.0;
          //栅格化处理
        _backView.layer.rasterizationScale = [[UIScreen mainScreen]scale];
          //正常矩形
          UIBezierPath *path = [UIBezierPath bezierPathWithRect:_backView.bounds];
        _backView.layer.shadowPath = path.CGPath;
    }
    
    return _backView;
}

@end
