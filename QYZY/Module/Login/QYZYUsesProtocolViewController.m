//
//  QYZYUsesProtocolViewController.m
//  QYZY
//
//  Created by jsmaster on 10/3/22.
//

#import "QYZYUsesProtocolViewController.h"
#import <WebKit/WebKit.h>

@interface QYZYUsesProtocolViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tileLbael;
@property (weak, nonatomic) IBOutlet WKWebView *webview;

@end

@implementation QYZYUsesProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tileLbael.text = self.vcTitle;
    [self.webview loadRequest:[NSURLRequest requestWithURL:self.url]];
}


- (IBAction)back:(UIButton *)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:true completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:true];
    }
}

@end
