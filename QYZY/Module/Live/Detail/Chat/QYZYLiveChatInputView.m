//
//  QYZYLiveChatInputView.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYLiveChatInputView.h"
#import "QYZYPhoneLoginViewController.h"

@interface QYZYLiveChatInputView ()<UITextViewDelegate>

@property (nonatomic ,strong) UIView *containerView;
@property (nonatomic ,strong) UIButton *giftButton;
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UILabel *loginLabel;
@property (nonatomic ,strong) UILabel *placeLabel;

@end

@implementation QYZYLiveChatInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setsubView];
        [self updateStatusWithUserModel:QYZYUserManager.shareInstance.userModel];
    }
    return self;
}

- (void)setsubView {
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 8;
    self.layer.shadowColor = rgba(216, 216, 218, 1).CGColor;
    self.layer.shadowRadius = 8;
    self.layer.shadowOffset = CGSizeMake(0, -2);
    self.layer.shadowOpacity = 0.15;
    
    [self addSubview:self.giftButton];
    [self.giftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-12);
        make.width.height.mas_equalTo(32);
    }];
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self.giftButton);
        make.right.equalTo(self.giftButton.mas_left).offset(-16);
        make.height.mas_equalTo(36);
    }];
    [self.containerView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView).offset(12);
        make.right.equalTo(self.containerView).offset(-12);
        make.top.bottom.equalTo(self.containerView);
    }];
    [self.containerView addSubview:self.loginLabel];
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView);
        make.left.equalTo(self.containerView).offset(18);
    }];
    [self.containerView addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView);
        make.left.equalTo(self.containerView).offset(18);
    }];
}

- (void)updateStatusWithUserModel:(QYZYUserModel *)userModel {
    self.loginLabel.hidden = userModel;
    [self textViewDidChange:self.textView];
}

- (void)commentAction {
    self.textView.text = @"";
    [self textViewDidChange:self.textView];
}

#pragma mark - delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!QYZYUserManager.shareInstance.isLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [UIViewController.currentViewController presentViewController:vc animated:true completion:nil];
        });
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!self.loginLabel.isHidden || self.textView.text.length) {
        self.placeLabel.hidden = YES;
    }
    else {
        self.placeLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        !self.commentBlock ? : self.commentBlock();
        [self commentAction];
        return NO;
    }
    return YES;
}

- (void)giftButtonAction {
    if (!QYZYUserManager.shareInstance.isLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [UIViewController.currentViewController presentViewController:vc animated:true completion:nil];
        });
        return;
    }
    [self.textView resignFirstResponder];
    !self.giftBlock ? : self.giftBlock();
}

#pragma mark - get
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = rgb(248, 250, 255);
        _containerView.layer.cornerRadius = 18;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIButton *)giftButton {
    if (!_giftButton) {
        _giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftButton setImage:[UIImage imageNamed:@"live_chat_gift"] forState:UIControlStateNormal];
        [_giftButton setImage:[UIImage imageNamed:@"live_chat_gift"] forState:UIControlStateHighlighted];
        [_giftButton addTarget:self action:@selector(giftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftButton;
}

- (UILabel *)loginLabel {
    if (!_loginLabel) {
        _loginLabel = [[UILabel alloc] init];
        _loginLabel.text = @"快去登录吧～";
        _loginLabel.textColor = rgb(41, 69, 192);
        _loginLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _loginLabel.hidden = YES;
    }
    return _loginLabel;
}

- (UILabel *)placeLabel {
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.text = @"开始你的评论～";
        _placeLabel.textColor = rgb(149, 157, 176);
        _placeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _placeLabel.hidden = YES;
    }
    return _placeLabel;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.delegate = self;
        _textView.backgroundColor = UIColor.clearColor;
        _textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _textView.tintColor = rgb(254, 56, 56);
        _textView.showsHorizontalScrollIndicator = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.returnKeyType = UIReturnKeySend;
    }
    return _textView;
}

@end
