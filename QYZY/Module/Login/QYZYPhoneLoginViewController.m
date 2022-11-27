//
//  QYZYPhoneLoginViewController.m
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import "QYZYPhoneLoginViewController.h"
#import "QYZYPasswordLoginApi.h"
#import "QYZYUserModel.h"
#import "QYZYPasswordLoginViewController.h"
#import "QYZYSendSMSCodeApi.h"
#import "QYZYPhoneLoginApi.h"
#import "QYZYUsesProtocolViewController.h"
#import "QYZYSettingPasswordViewController.h"


NSString * const QYZYLoginSuccessNotification = @"com.qyzy.login.success";

@interface QYZYPhoneLoginViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *userNameTF;
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property(nonatomic, assign) BOOL hasGetCode;
@property(nonatomic, assign) BOOL hasAgree;

@end

@implementation QYZYPhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    BOOL hasReadAgreement = [[self readArchiverCachePath:ReadLoginAgreementKey] boolValue];
    self.agreeBtn.selected = hasReadAgreement;
    self.hasAgree = self.agreeBtn.isSelected;
}

- (IBAction)backBtnDidClciked:(UIButton *)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:true completion:^{
                    
        }];
    } else {
        [self.navigationController popoverPresentationController];
    }
}

- (IBAction)passwordLoginBtnDidClicked:(UIButton *)sender {
    [self presentViewController:[QYZYPasswordLoginViewController new] animated:true completion:nil];
}

- (IBAction)codeBtnDidClicked:(UIButton *)sender {
   
    if (self.userNameTF.text.qmui_trim.length != 11) {
        [self.view qyzy_showMsg:@"请输入正确的手机号码"];
        return;
    }
    
    self.hasGetCode = true;
    
    QYZYSendSMSCodeApi *api = [QYZYSendSMSCodeApi new];
    api.phone = self.userNameTF.text.qmui_trim;
    api.type = @"1";
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self countDownCodeBtn:sender];
        [self.view qyzy_showMsg:@"验证码发送成功"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
}

- (IBAction)agreeBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.hasAgree = sender.isSelected;
    [self saveArchiverCacheRootObject:@(sender.isSelected) Path:ReadLoginAgreementKey];
}

- (IBAction)serviceBtnDidCicked:(UIButton *)sender {
    QYZYUsesProtocolViewController *vc = [QYZYUsesProtocolViewController new];
    vc.vcTitle = @"用户协议";
    vc.url = [[NSBundle mainBundle] URLForResource:@"qwty" withExtension:@"html"];
    [self presentViewController:vc animated:true completion:nil];
}


- (IBAction)loginBtnDidClicked:(UIButton *)sender {
    if (self.userNameTF.text.qmui_trim.length != 11) {
        [self.view qyzy_showMsg:@"请输入正确的手机号"];
        return;
    }
    
    if (self.passwordTF.text.qmui_trim.length <= 0) {
        [self.view qyzy_showMsg:@"请输入验证码"];
        return;
    }
    
    if (self.hasGetCode == false) {
        [self.view qyzy_showMsg:@"请先获取验证码"];
        return;
    }
    
    if (self.hasAgree == false) {
        [self.view qyzy_showMsg:@"登录前请同意协议"];
        return;
    }
    
    QYZYPhoneLoginApi *api = [QYZYPhoneLoginApi new];
    api.userName = self.userNameTF.text.qmui_trim;
    api.code = self.passwordTF.text.qmui_trim;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        QYZYUserModel *userModel = [QYZYUserModel yy_modelWithJSON:request.responseObject[@"data"]];
        [QYZYUserManager.shareInstance saveUserModel:userModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:QYZYLoginSuccessNotification object:nil];

        
        if ([userModel.isRes boolValue] == true) {
            QYZYSettingPasswordViewController *vc = [QYZYSettingPasswordViewController new];
            vc.userName = self.userNameTF.text.qmui_trim;
            vc.ticket = userModel.ticket;
            [self presentViewController:vc animated:true completion:nil];
        } else {
            [UIView qyzy_showMsg:@"登录成功"];
            [self dismissViewControllerAnimated:true completion:nil];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
    
}

- (void)countDownCodeBtn:(UIButton *)sender {
    NSString *origin = sender.titleLabel.text;
    __block NSInteger count = 60;
    sender.enabled = false;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:true block:^(NSTimer * _Nonnull timer) {
        if (count == 0) {
            sender.enabled = true;
            [sender setTitle:origin forState:UIControlStateNormal];
            [timer invalidate];
        } else {
            [sender setTitle:[NSString stringWithFormat:@"%ld后重发", --count] forState:UIControlStateNormal];
        }
    }];
    [timer fire];
}

- (NSString *)getArchiverCachePath:(NSString *)path {
    return [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), path];
}

- (id)readArchiverCachePath:(NSString *)path {
    if (path.length == 0) return nil;
    NSString * filePath = [self getArchiverCachePath:path];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)saveArchiverCacheRootObject:(id)rootObject Path:(NSString *)path {
    if (path.length == 0 || !rootObject) return;
    NSString * filePath = [self getArchiverCachePath:path];
    [NSKeyedArchiver archiveRootObject:rootObject toFile:filePath];
}

@end
