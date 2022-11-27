//
//  QYZYSettingPasswordViewController.m
//  QYZY
//
//  Created by jsmaster on 10/3/22.
//

#import "QYZYSettingPasswordViewController.h"
#import "QYZYSettingPaswwordApi.h"
#import "QYZYGetSetPasswordTicketApi.h"

@interface QYZYSettingPasswordViewController ()
@property (weak, nonatomic) IBOutlet QMUITextField *passwordTF;

@end

@implementation QYZYSettingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)secureTextBtnDidClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTF.secureTextEntry = !sender.selected;
}

- (IBAction)sureBtnDidClicked:(UIButton *)sender {
    if (self.passwordTF.text.qmui_trim.length < 6 || self.passwordTF.text.qmui_trim.length > 32) {
        [self.view qyzy_showMsg:@"输入的密码6到32位"];
        return;
    }
    
    QYZYSettingPaswwordApi *api = [QYZYSettingPaswwordApi new];
    api.userName = self.userName;
    api.passWord = self.passwordTF.text.qmui_trim;
    api.ticket = self.ticket;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"设置密码成功"];
        UIViewController *presentingViewController = self.presentingViewController;
        [self dismissViewControllerAnimated:false completion:^{
            [presentingViewController dismissViewControllerAnimated:false completion:nil];
        }];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
    
    
}

@end
