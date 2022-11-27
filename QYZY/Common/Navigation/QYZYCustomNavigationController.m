//
//  QYZYCustomNavigationController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCustomNavigationController.h"

@interface QYZYCustomNavigationController ()

@end

@implementation QYZYCustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigation];
}

- (void)configNavigation {
    [self.navigationBar setBackgroundImage:[UIImage qmui_imageWithColor:rgb(41, 69, 192)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = false;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:16],NSForegroundColorAttributeName : rgb(196, 220, 255)};
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *app = [[UINavigationBarAppearance alloc] init];
        [app configureWithDefaultBackground];
        app.backgroundColor = rgb(41, 69, 192);
        app.shadowColor = UIColor.clearColor;
        app.backgroundEffect = nil;
        UINavigationBar.appearance.scrollEdgeAppearance = app;
        UINavigationBar.appearance.standardAppearance = app;
        app.titleTextAttributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:16],NSForegroundColorAttributeName : rgb(196, 220, 255)};
    }

}

@end
