//
//  QYZYCustomerserviceViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYCustomerserviceViewController.h"
#import <WKWebView+AFNetworking.h>
#import "QYZYCustomerserviceApi.h"

@interface QYZYCustomerserviceViewController ()
@property (nonatomic,strong) WKWebView *webView;

@end

@implementation QYZYCustomerserviceViewController


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
    self.title = @"在线客服";
    [self.view addSubview:self.webView];
    QYZYCustomerserviceApi *api = [QYZYCustomerserviceApi new];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *path = request.responseObject[@"data"][@"echatUrl"];
        NSURL *url = [NSURL URLWithString:path];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
}


- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavigationBarHeight)];
    }
    
    return _webView;
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
