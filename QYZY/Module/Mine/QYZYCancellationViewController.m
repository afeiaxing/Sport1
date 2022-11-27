//
//  QYZYCancellationViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYCancellationViewController.h"
#import "QYZYSendSMSCodeApi.h"
#import "QYZYCancellation.h"

@interface QYZYCancellationViewController ()<UITextFieldDelegate>
// 验证码 提示 codeTipLabel
@property (nonatomic, strong) UILabel *codeTipLabel;
// 手机号码 提示 phoneTipLabel
@property (nonatomic, strong) UILabel *phoneTipLabel;
// 温馨提示 warmTipLabel
@property (nonatomic, strong) UILabel *warmTipLabel;
// 确定 按键 sureButton
@property (nonatomic, strong) UIButton *sureButton;

//验证码输入框
@property (nonatomic, strong) UITextField *textField;

//获取验证码按钮
@property (nonatomic, strong) UIButton *codeButton;

@end

@implementation QYZYCancellationViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{

  self.tabBarController.tabBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注销账户";
    [self setUI];
    [self layoutViewControls];
    
}

- (void)setUI {
    [self.view addSubview:self.codeTipLabel];
    [self.view addSubview:self.phoneTipLabel];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.warmTipLabel];
    [self.view addSubview:self.codeButton];
}

- (void)layoutViewControls {
    
    [self.codeTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(30);
        make.left.equalTo(self.view).mas_offset(14);
    }];
    
    [self.phoneTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeTipLabel.mas_bottom).mas_offset(5);
        make.left.mas_offset(14);
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTipLabel.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(14);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(250);
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTipLabel.mas_bottom).mas_equalTo(10);
        make.left.equalTo(self.textField.mas_right).mas_equalTo(20);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(60);
    }];
    

    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField.mas_bottom).mas_equalTo(30);
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.height.mas_equalTo(45);
    }];

    [self.warmTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sureButton.mas_bottom).mas_equalTo(30);
        make.left.right.equalTo(self.sureButton);
    }];
}



- (NSString *)phoneTipString {
    NSString *phone = [NSString stringWithFormat:@"%@",[QYZYUserManager shareInstance].userModel.mobile];
    if (phone.length > 7) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return  [NSString stringWithFormat:@"%@", phone];
}



#pragma mark - UITextField Delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length >= 5) {
        self.sureButton.enabled = YES;
        [self.sureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    else
    {
        self.sureButton.enabled = NO;
        [self.sureButton setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    }
    
    return YES;
}


//确认注销
- (void)sureButtonClick:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定真的要注销账号吗？\n注销后，账号相关权益将被完全删除" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self CancellationApi];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    

}

- (void)CancellationApi
{
    weakSelf(self);
    QYZYCancellation *api = [QYZYCancellation new];
    api.code = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:@"注销成功"];
        
        [QYZYUserManager shareInstance].userModel = nil;
        [QYZYUserManager.shareInstance saveUserModel:[QYZYUserManager shareInstance].userModel];
        self.tabBarController.selectedIndex = 0;
        [weakself.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:QYZYExitLoginSuccessNotification object:nil];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
}


//获取验证码
- (void)codeClick:(UIButton *)button
{
    
    [self getVeriCode];
 
    __block int timeout = 60;
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, global);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        timeout --;
        if (timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.codeButton.userInteractionEnabled = YES;
                [weakSelf.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                });
        }else {

            dispatch_async(dispatch_get_main_queue(), ^{
                NSString * title = [NSString stringWithFormat:@"%d秒后获取",timeout];
                [weakSelf.codeButton setTitle:title forState:UIControlStateNormal];
                weakSelf.codeButton.userInteractionEnabled = NO;
                });
        }
        });
    
    dispatch_resume(timer);
}

- (void)getVeriCode
{
    QYZYSendSMSCodeApi *api = [QYZYSendSMSCodeApi new];
    api.phone = [QYZYUserManager shareInstance].userModel.mobile;
    api.type = @"6";
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:@"验证码发送成功"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
}



- (UILabel *)codeTipLabel {
    if (!_codeTipLabel) {
        _codeTipLabel = [[UILabel alloc] init];
        _codeTipLabel.font = [UIFont systemFontOfSize:18];
        _codeTipLabel.textColor = rgb(65, 70, 85);
        _codeTipLabel.text = @"验证码将发送到手机：";
    }
    return _codeTipLabel;
}

- (UILabel *)phoneTipLabel {
    if (!_phoneTipLabel) {
        _phoneTipLabel = [[UILabel alloc] init];
        _phoneTipLabel.textColor = rgb(41, 69, 192);
        _phoneTipLabel.font = [UIFont systemFontOfSize:16];
        _phoneTipLabel.text = [self phoneTipString];
    }
    return _phoneTipLabel;
}

- (UILabel *)warmTipLabel {
    if (!_warmTipLabel) {
        _warmTipLabel = [[UILabel alloc] init];
        _warmTipLabel.textColor = rgb(165, 165, 165);
        _warmTipLabel.font = [UIFont systemFontOfSize:14];
        _warmTipLabel.numberOfLines = 0;
        _warmTipLabel.text = @"关于注销账户的特别说明：\n （1）账号一旦注销，您将无法登录、使用该账号，也就是说您将无法再以此账号登录/使用/继续使用球王的相关产品与服务；\n （2）账号一旦注销，您曾通过该账号登录、使用的产品与服务下的所有内容、信息、数据、记录将会被删除或匿名化处理，您也无法再检索、访问、获取、继续使用和找回，也无权要求我们找回（但法律法规另有规定或监管部门另有要求的除外），包括： 该账号下的个人资料（例如：头像、昵称）及绑定信息（例如：绑定手机号、邮箱）； 该账号下的您的个人信息；该账号曾发表的所有内容（例如：图片、照片、评论、互动、点赞）；其他所有内容、信息、数据、记录。\n （3）账号一旦注销，您与我们曾签署过的相关用户协议、其他权利义务性文件等相应终止（但我们与您之间已约定继续生效的或法律法规另有规定的除外）；\n";
    }
    return _warmTipLabel;
}



- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] init];
        [_sureButton setBackgroundColor:rgb(41, 69, 192)];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureButton.enabled = NO;
        [_sureButton setTitle:@"确定注销" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor.whiteColor colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        NSDictionary *attrDic = @{NSForegroundColorAttributeName : rgb(165, 165, 165),
                                  NSFontAttributeName : [UIFont systemFontOfSize:16]};
        NSAttributedString *holderTitle = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:attrDic];
        _textField.attributedPlaceholder = holderTitle;
    }
    
    return _textField;
}


- (UIButton *)codeButton
{
    if (!_codeButton) {
        _codeButton = [[UIButton alloc]init];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:rgb(255, 255, 255) forState:UIControlStateNormal];
        _codeButton.backgroundColor  = rgb(41, 69, 192);
        _codeButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_codeButton addTarget:self action:@selector(codeClick:) forControlEvents:UIControlEventTouchUpInside];
        _codeButton.layer.masksToBounds = YES;
        _codeButton.layer.cornerRadius = 12;
    }
    
    return _codeButton;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
