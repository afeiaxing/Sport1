//
//  QYZYSetTableViewCell.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYSetTableViewCell.h"

@implementation QYZYSetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addConstraintsAndActions];
    }
    return self;
}

- (void)addConstraintsAndActions
{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
    }];
    
    [self addSubview:self.rigLabel];
    [self.rigLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (UILabel *)rigLabel
{
    if (!_rigLabel) {
        _rigLabel = [[UILabel alloc]init];
        _rigLabel.font = [UIFont systemFontOfSize:12];
        _rigLabel.textColor = rgb(149, 157, 176);
    }
    return _rigLabel;
}
@end
