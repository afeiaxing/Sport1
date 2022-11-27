//
//  FSCalendarCustomView.m
//  XMSport
//
//  Created by jsarcherr on 2021/12/4.
//  Copyright © 2021 XMSport. All rights reserved.
//

#import "FSCalendarCustomView.h"

@interface FSCalendarCustomView()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *conformBtn;

@end

@implementation FSCalendarCustomView

#pragma mark - lifecycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSbbviews];
    }
    return self;
}

#pragma mark - private
- (void)setupSbbviews{
    [self addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.size.mas_equalTo(CGSizeMake(130, 40));
        make.centerY.offset(0);
    }];
    
    [self addSubview:self.conformBtn];
    [self.conformBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.width.height.centerY.equalTo(self.cancelBtn);
    }];
}

- (void)handleCancelEvent{
    !self.cancelBlock ? : self.cancelBlock();
}

- (void)handleConformEvent{
    !self.conformBlock ? : self.conformBlock();
}

#pragma mark - setter & getter
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.layer.cornerRadius = (5);
        _cancelBtn.layer.masksToBounds = true;
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _cancelBtn.backgroundColor = rgb(222, 228, 255);
        [_cancelBtn addTarget:self action:@selector(handleCancelEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)conformBtn{
    if (!_conformBtn) {
        _conformBtn = [UIButton new];
        _conformBtn.layer.cornerRadius = (5);
        _conformBtn.layer.masksToBounds = true;
        _conformBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [_conformBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_conformBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _conformBtn.backgroundColor = rgb(41, 69, 192);
        [_conformBtn addTarget:self action:@selector(handleConformEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _conformBtn;
}

@end
