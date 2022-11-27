//
//  AppDelegate.m
//  QYZY
//
//  Created by jsmaster on 9/27/22.
//

#import "AppDelegate.h"
#import "QYZYMineViewController.h"
#import "QYZYCircleViewController.h"
#import "QYZYNewsViewController.h"
#import "QYZYLiveViewController.h"
#import "QYZYMatchViewController.h"
#import "QYZYAppConfig.h"
#import "JPUSHService.h"
#import "QYZYCustomNavigationController.h"
#import "QYZYCustomRequestFilter.h"
#import "QYZYUserManager.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [QYZYAppConfig configWithapplication:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self setupTabbarVC];
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitUser:) name:QYZYUserExitNotification object:nil];
    
    return YES;
}

- (UITabBarController *)setupTabbarVC {
    UITabBarController * tabbarVC = [[UITabBarController alloc]init];
    tabbarVC.tabBar.barTintColor = rgb(35, 57, 180);
    if (@available(iOS 15.0, *)) {
        tabbarVC.tabBar.scrollEdgeAppearance = tabbarVC.tabBar.standardAppearance;
    }
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : rgba(196, 220, 255,1)} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName : rgba(174, 182, 200,1)} forState:UIControlStateSelected];
    
    tabbarVC.tabBar.tintColor = rgba(196, 220, 255,1);
    tabbarVC.tabBar.unselectedItemTintColor = rgba(174, 182, 200,1);
    
    [self addChildVCWithTabbarVC:tabbarVC vc:QYZYMatchViewController.new title:@"赛事" selectedImage:@"tabSaichengH" image:@"tabSaichengN"];
    [self addChildVCWithTabbarVC:tabbarVC vc:QYZYLiveViewController.new title:@"直播" selectedImage:@"tabZhiboH" image:@"tabZhiboN"];
    [self addChildVCWithTabbarVC:tabbarVC vc:QYZYNewsViewController.new title:@"资讯" selectedImage:@"tabZixunH" image:@"tabZixunN"];
    [self addChildVCWithTabbarVC:tabbarVC vc:QYZYCircleViewController.new title:@"发现" selectedImage:@"tabFaxianH" image:@"tabFaxianN"];
    [self addChildVCWithTabbarVC:tabbarVC vc:QYZYMineViewController.new title:@"我的" selectedImage:@"tabWodeH" image:@"tabWodeN"];
    
    tabbarVC.selectedIndex = 1;
    
    return tabbarVC;
}

- (void)addChildVCWithTabbarVC:(UITabBarController *)tabbaeVC vc:(UIViewController *)vc title:(NSString *)title selectedImage:(NSString *)selectedImage image:(NSString *)image {
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [tabbaeVC addChildViewController:[[QYZYCustomNavigationController alloc] initWithRootViewController:vc]];
}

- (void)exitUser:(NSNotification *)note {
    [QYZYUserManager.shareInstance saveUserModel:nil];
    NSString *info = note.userInfo[QYZYUserExitNotificationInfoKey];
    [UIView qyzy_showMsg:info];
    self.window.rootViewController = [self setupTabbarVC];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
     [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
     completionHandler(UIBackgroundFetchResultNewData);
}

@end
