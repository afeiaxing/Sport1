//
//  QYZYRankTableViewCell.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYRankTableViewCell.h"

@implementation QYZYRankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addConstraintsAndActions];
        self.backgroundColor = rgb(247, 248, 254);
    }
    return self;
}


- (void)updataUI:(QYZYRankModel *)model isDay:(BOOL)isDay
{
    NSLog(@"%@",model);
    
    if (isDay == YES) {
        self.fansLabel.text = [NSString stringWithFormat:@"粉丝数 %@",model.experience];
    }
    else
    {
        self.fansLabel.text = [NSString stringWithFormat:@"豪气值 %@",model.price];
    }
    self.nameLabel.text = model.nickname;
    
    [self.hadeImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
    
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
    
    [self.backView addSubview:self.rankLabel];
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(18);
    }];

    [self.backView addSubview:self.hadeImageView];
    [self.hadeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(44);
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

- (UIImageView *)image
{
    if (!_image) {
        _image = [[UIImageView alloc]init];
    }
    return _image;
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
        _backView.layer.masksToBounds = NO;
          
        _backView.layer.borderWidth  = 0.0;
          
        _backView.layer.opaque = 0.10;
          
        _backView.layer.cornerRadius = 8.0;
        _backView.layer.rasterizationScale = [[UIScreen mainScreen]scale];
          UIBezierPath *path = [UIBezierPath bezierPathWithRect:_backView.bounds];
        _backView.layer.shadowPath = path.CGPath;
    }
    
    return _backView;
}

- (UILabel *)rankLabel
{
    if (!_rankLabel) {
        _rankLabel = [[UILabel alloc]init];
        _rankLabel.textColor = rgb(34, 34, 34);
        _rankLabel.font = [UIFont systemFontOfSize:20];
        _rankLabel.text = @"1";
    }
    return _rankLabel;
}
@end
