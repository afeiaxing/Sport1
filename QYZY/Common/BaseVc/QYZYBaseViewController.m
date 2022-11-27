//
//  QYZYBaseViewController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/5.
//

#import "QYZYBaseViewController.h"

@interface QYZYBaseViewController ()

@end

@implementation QYZYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLeftItem];
}

- (void)configLeftItem {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage: [UIImage imageNamed:@"news_search_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
}

- (void)backAction {
    if (self.navigationController.viewControllers.count <= 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setLeftItem:(UIView *)leftItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItem];
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
}

- (void)setRightItem:(UIView *)rightItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
}

@end
