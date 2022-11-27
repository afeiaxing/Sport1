//
//  QYZYScheduleHeaderVIew.m
//  QYZY
//
//  Created by jspatches on 2022/9/29.
//

#import "QYZYScheduleHeaderVIew.h"

@implementation QYZYScheduleHeaderVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addConstraintsAndActions];
    }
    return self;
}

#pragma mark - creatUI lazy

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = rgb(149, 157, 176);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = rgb(225, 228, 242);
        [self.backView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor =  rgb(247, 248, 254);
        [self addSubview:_backView];
    }
    return _backView;
}


#pragma mark - layout
- (void)addConstraintsAndActions
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(90);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self);
    }];
}
@end
