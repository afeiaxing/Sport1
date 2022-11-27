//
//  QYZYCircleDetailHeader.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleDetailHeader.h"

@interface QYZYCircleDetailHeader ()

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation QYZYCircleDetailHeader

#pragma mark - lazy load
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = rgb(248, 250, 255);
    }
    return _container;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = rgb(255, 255, 255);
    }
    return _titleView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _titleLab.textColor = rgb(34, 34, 34);
    }
    return _titleLab;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    return self;
}

- (void)configCell {
    [self.contentView addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.container addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.container);
        make.top.equalTo(self.container).offset(12);
    }];
    
    [self.titleView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleView).offset(12);
        make.centerY.equalTo(self.titleView);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (title.length == 0) {
        self.titleView.hidden = YES;
        self.titleLab.text = @"";
    }else {
        self.titleView.hidden = NO;
        self.titleLab.text = title;
    }
}

@end
