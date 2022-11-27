//
//  QYZYNodataTableViewCell.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYNodataTableViewCell.h"

@implementation QYZYNodataTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addConstraintsAndActions];
    }
    return self;
}

- (void)addConstraintsAndActions
{
    [self addSubview:self.nodaImageView];
    [self.nodaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(150);
        make.width.mas_equalTo(200);
        
    }];
    
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nodaImageView.mas_bottom).mas_equalTo(10);
        make.centerX.mas_equalTo(0);
    }];
}


- (UIImageView *)nodaImageView
{
    if (!_nodaImageView) {
        _nodaImageView = [[UIImageView alloc]init];
        _nodaImageView.image = [UIImage imageNamed:@"empty_noData"];
    }
    return _nodaImageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.text = @"暂无数据～";
        _label.font = [UIFont systemFontOfSize:15];
    }
    return _label;
}

@end
