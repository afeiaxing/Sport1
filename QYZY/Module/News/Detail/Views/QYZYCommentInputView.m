//
//  QYZYCommentInputView.m
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import "QYZYCommentInputView.h"

@interface QYZYCommentInputView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *talkBgView;

@property (nonatomic, strong) UILabel *placeHolderLab;

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation QYZYCommentInputView

#pragma mark - lazy load

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _sendBtn.alpha = 0;
        [_sendBtn addTarget:self action:@selector(sendMsg:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIView *)talkBgView {
    if (!_talkBgView) {
        _talkBgView = [[UIView alloc] init];
        _talkBgView.backgroundColor = rgb(248, 250, 255);
        _talkBgView.layer.cornerRadius = 18;
    }
    return _talkBgView;
}


- (UILabel *)placeHolderLab {
    if (!_placeHolderLab) {
        _placeHolderLab = [[UILabel alloc] init];
        _placeHolderLab.text = @"说些什么~";
        _placeHolderLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _placeHolderLab.textColor = rgb(149, 157, 176);
    }
    return _placeHolderLab;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = UIColor.clearColor;
        _textView.delegate = self;
    }
    return _textView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configCell];
    }
    return self;
}

- (void)configCell {
    [self addSubview:self.talkBgView];
    [self.talkBgView addSubview:self.textView];
    [self.talkBgView addSubview:self.placeHolderLab];
    [self addSubview:self.sendBtn];
    
    [self.talkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-12);
        make.top.equalTo(self).offset(8);
        make.height.mas_offset(36);
    }];
    
    
    [self.placeHolderLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.talkBgView);
        make.left.equalTo(self.talkBgView).offset(18);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.talkBgView).offset(12);
        make.right.equalTo(self.talkBgView).offset(-12);
        make.top.equalTo(self.talkBgView).offset(3);
        make.bottom.equalTo(self.talkBgView);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(50);
        make.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-6);
        make.height.mas_offset(36);
    }];
}

- (void)updateInputViewWithStatus:(BOOL)isShow {
    if (isShow) {
        [self.talkBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-59);
            make.top.equalTo(self).offset(8);
            make.height.mas_offset(36);
        }];
        
        self.sendBtn.alpha = 1;
        [UIView animateWithDuration:0.35f animations:^{
            [self layoutIfNeeded];
        }];
    }else {
        [self.talkBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self).offset(-12);
            make.top.equalTo(self).offset(8);
            make.height.mas_offset(36);
        }];
        
        self.sendBtn.alpha = 0;
        
        [UIView animateWithDuration:0.35f animations:^{
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - action
- (void)sendMsg:(UIButton *)sender {
    if (!QYZYUserManager.shareInstance.isLogin) {
        
        QYZYPhoneLoginViewController *loginVc = [QYZYPhoneLoginViewController new];
        [[self currentVc].navigationController presentViewController:loginVc animated:YES completion:nil];
        return;
    }
    !self.msgSendBlock?:self.msgSendBlock(self.textView.text);
}

#pragma mark -- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!QYZYUserManager.shareInstance.isLogin) {
        
        QYZYPhoneLoginViewController *loginVc = [QYZYPhoneLoginViewController new];
        [[self currentVc].navigationController presentViewController:loginVc animated:YES completion:nil];
        return NO;
    }
    self.placeHolderLab.text = @"";

    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.placeHolderLab.text = @"说些什么~";
}

- (UIViewController*)currentVc{
    
    UIViewController* vc = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

@end
