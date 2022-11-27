//
//  QYZYPhoneLoginViewController.m
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import "QYZYPasswordLoginViewController.h"
#import "QYZYPasswordLoginApi.h"
#import "QYZYUserModel.h"
#import "QYZYPhoneLoginViewController.h"
#import "QYZYUsesProtocolViewController.h"

@interface QYZYPasswordLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property(nonatomic, assign) BOOL hasAgree;

@end

@implementation QYZYPasswordLoginViewController

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
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        [self.navigationController popoverPresentationController];
    }
}

- (IBAction)phoneBtnDidClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)secureTextBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTF.secureTextEntry = !sender.selected;
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
    
    if (self.hasAgree == false) {
        [self.view qyzy_showMsg:@"登录前请同意协议"];
        return;
    }
    
    QYZYPasswordLoginApi *api = [QYZYPasswordLoginApi passwordLoginApiWithUserName:self.userNameTF.text password:self.passwordTF.text];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"登录成功"];
        QYZYUserModel *userModel = [QYZYUserModel yy_modelWithJSON:request.responseObject[@"data"]];
        [QYZYUserManager.shareInstance saveUserModel:userModel];
        UIViewController *presentingViewController = self.presentingViewController;
        [self dismissViewControllerAnimated:false completion:^{
            [presentingViewController dismissViewControllerAnimated:false completion:nil];
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:QYZYLoginSuccessNotification object:nil];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
    
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
