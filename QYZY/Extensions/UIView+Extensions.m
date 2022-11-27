//
//  UIView+Extensions.m
//  QYZY
//
//  Created by jsmaster on 10/2/22.
//

#import "UIView+Extensions.h"
#import "MBProgressHUD.h"

@implementation UIView (Extensions)

static char kAssociatedObjectKey_cornerRadius;
- (void)setQyzy_cornerRadius:(CGFloat)qyzy_cornerRadius {
    objc_setAssociatedObject(self, &kAssociatedObjectKey_cornerRadius, @(qyzy_cornerRadius), OBJC_ASSOCIATION_ASSIGN);
    [self _createCornner:qyzy_cornerRadius];
    [self setNeedsLayout];
}

- (CGFloat)qyzy_cornerRadius {
    return [(NSNumber *)objc_getAssociatedObject(self, &kAssociatedObjectKey_cornerRadius) floatValue];
}

- (void)_createCornner:(CGFloat)qyzy_cornerRadius {
    self.layer.cornerRadius = qyzy_cornerRadius;
    self.layer.masksToBounds = true;
}

+ (void)qyzy_showLoadingWithMsg:(NSString *)msg {
    [self qyzy_showLoadingWithMsg:msg OnView:UIApplication.sharedApplication.delegate.window];
}

- (void)qyzy_showLoadingWithMsg:(NSString *)msg {
    [self.class qyzy_showLoadingWithMsg:msg OnView:self];
}

+ (void)qyzy_hideLoading {
    [self qyzy_hideLoadingOnView:UIApplication.sharedApplication.delegate.window];
}

- (void)qyzy_hideLoading {
    [self.class qyzy_hideLoadingOnView:self];
}

+ (void)qyzy_hideLoadingOnView:(UIView *)view {
    MBProgressHUD *hud = (MBProgressHUD *)objc_getAssociatedObject(view, &kAssociatedObjectKey_showLoading);
    if (hud) {
        [hud hideAnimated:true];
    }
}

static char kAssociatedObjectKey_showLoading;
+ (void)qyzy_showLoadingWithMsg:(NSString *)msg OnView:(UIView *)view {
    MBProgressHUD *hud = (MBProgressHUD *)objc_getAssociatedObject(view, &kAssociatedObjectKey_showLoading);
    if (hud) {
        hud.label.text = msg;
    } else {
        MBProgressHUD *hud = [[MBProgressHUD alloc] init];
        hud.removeFromSuperViewOnHide = true;
        hud.label.text = msg;
        [view addSubview:hud];
        [hud showAnimated:true];
        
        objc_setAssociatedObject(view, &kAssociatedObjectKey_showLoading, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (void)qyzy_showMsg:(NSString *)msg OnView:(UIView *)view {
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    hud.removeFromSuperViewOnHide = true;
    hud.mode = MBProgressHUDModeCustomView;

    UILabel *label = [[UILabel alloc] init];
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.customView = label;

    [hud.bezelView setStyle:MBProgressHUDBackgroundStyleSolidColor];
    hud.bezelView.color = [UIColor clearColor];
    [view addSubview:hud];
    [hud showAnimated:true];
    [hud hideAnimated:true afterDelay:2.0];
}

+ (void)qyzy_showMsg:(NSString *)msg {
    [self qyzy_hideLoading];
    [self qyzy_showMsg:msg OnView:UIApplication.sharedApplication.delegate.window];
}

- (void)qyzy_showMsg:(NSString *)msg {
    [self qyzy_hideLoading];
    [self.class qyzy_showMsg:msg OnView:self];
}

@end
