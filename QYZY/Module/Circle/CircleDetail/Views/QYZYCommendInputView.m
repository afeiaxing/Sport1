//
//  QYZYCommendInputView.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCommendInputView.h"
#import "QYZYCircleDetailController.h"
#import "QYZYPhoneLoginViewController.h"

@interface QYZYCommendInputView ()<UITextViewDelegate>

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commendBtn;

@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, strong) UIView *talkBgView;

@property (nonatomic, strong) UILabel *placeHolderLab;

@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation QYZYCommendInputView

#pragma mark - lazy load
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"utils_share"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

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

- (UIButton *)likeBtn {
    if (!_likeBtn) {
        _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_likeBtn setImage:[UIImage imageNamed:@"utils_like_normal"] forState:UIControlStateNormal];
        [_likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _likeBtn;
}

- (UIButton *)collectBtn {
    if (!_collectBtn) {
        _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectBtn setImage:[UIImage imageNamed:@"utils_collect_normal"] forState:UIControlStateNormal];
        [_collectBtn addTarget:self action:@selector(collectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBtn;
}

- (UIView *)talkBgView {
    if (!_talkBgView) {
        _talkBgView = [[UIView alloc] init];
        _talkBgView.backgroundColor = rgb(248, 250, 255);
        _talkBgView.layer.cornerRadius = 18;
    }
    return _talkBgView;
}

- (UIButton *)commendBtn {
    if (!_commendBtn) {
        _commendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commendBtn setTitle:@"0" forState:UIControlStateNormal];
        [_commendBtn setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
        _commendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [_commendBtn setImage:[UIImage imageNamed:@"utils_commend"] forState:UIControlStateNormal];
    }
    return _commendBtn;
}

- (UILabel *)placeHolderLab {
    if (!_placeHolderLab) {
        _placeHolderLab = [[UILabel alloc] init];
        _placeHolderLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _placeHolderLab.textColor = rgb(149, 157, 176);
        _placeHolderLab.text = @"说些什么~";
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

- (void)setIsLike:(BOOL)isLike {
    _isLike = isLike;
    if (isLike) {
        [self.likeBtn setImage:[UIImage imageNamed:@"utils_like_select"] forState:UIControlStateNormal];
    }else {
        [self.likeBtn setImage:[UIImage imageNamed:@"utils_like_normal"] forState:UIControlStateNormal];
    }
}

- (void)setIsFavorites:(BOOL)isFavorites {
    _isFavorites = isFavorites;
    if (isFavorites) {
        [self.collectBtn setImage:[UIImage imageNamed:@"utils_collect_select"] forState:UIControlStateNormal];
    }else {
        [self.collectBtn setImage:[UIImage imageNamed:@"utils_collect_normal"] forState:UIControlStateNormal];
    }
}

- (void)setCommentCount:(NSString *)commentCount {
    _commentCount = commentCount;
    [self.commendBtn setTitle:commentCount forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configCell];
    }
    return self;
}

- (void)configCell {
    [self addSubview:self.shareBtn];
    [self addSubview:self.collectBtn];
    [self addSubview:self.likeBtn];
    [self addSubview:self.commendBtn];
    [self addSubview:self.talkBgView];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(36);
        make.top.equalTo(self).offset(8);
        make.right.equalTo(self).offset(-12);
    }];
    
    [self.collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(36);
        make.centerY.equalTo(self.shareBtn);
        make.right.equalTo(self.shareBtn.mas_left).offset(-2);
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(36);
        make.centerY.equalTo(self.shareBtn);
        make.right.equalTo(self.collectBtn.mas_left).offset(-2);
    }];
    
    [self.commendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(36);
        make.width.mas_offset(50);
        make.centerY.equalTo(self.shareBtn);
        make.right.equalTo(self.likeBtn.mas_left).offset(-2);
    }];
    
    [self.talkBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.right.equalTo(self.commendBtn.mas_left).offset(-3);
        make.top.equalTo(self).offset(8);
        make.height.mas_offset(36);
    }];
    
    [self.talkBgView addSubview:self.textView];
    [self.talkBgView addSubview:self.placeHolderLab];
    [self addSubview:self.sendBtn];
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
        self.shareBtn.alpha = 0;
        
        [UIView animateWithDuration:0.35f animations:^{
            [self layoutIfNeeded];
        }];
    }else {
        [self.talkBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(12);
            make.right.equalTo(self.commendBtn.mas_left).offset(-3);
            make.top.equalTo(self).offset(8);
            make.height.mas_offset(36);
        }];
        
        self.sendBtn.alpha = 0;
        self.shareBtn.alpha = 1;
        
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

- (void)likeClick:(UIButton *)sender {
    if (!QYZYUserManager.shareInstance.isLogin) {
        
        QYZYPhoneLoginViewController *loginVc = [QYZYPhoneLoginViewController new];
        [[self currentVc].navigationController presentViewController:loginVc animated:YES completion:nil];
        return;
    }
    !self.likeClickBlock?:self.likeClickBlock();
}

- (void)collectClick:(UIButton *)sender {
    if (!QYZYUserManager.shareInstance.isLogin) {
        
        QYZYPhoneLoginViewController *loginVc = [QYZYPhoneLoginViewController new];
        [[self currentVc].navigationController presentViewController:loginVc animated:YES completion:nil];
        return;
    }
    !self.collectClickBlock?:self.collectClickBlock();
}

- (void)shareClick {
    !self.shareClickBlock ?: self.shareClickBlock();
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

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.placeHolderLab.hidden = YES;
    }else {
        self.placeHolderLab.hidden = NO;
    }
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
