//
//  UIView+Extensions.h
//  QYZY
//
//  Created by jsmaster on 10/2/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extensions)

@property(nonatomic, assign) IBInspectable CGFloat qyzy_cornerRadius;

+ (void)qyzy_showLoadingWithMsg:(NSString *)msg;
- (void)qyzy_showLoadingWithMsg:(NSString *)msg;
+ (void)qyzy_hideLoading;
- (void)qyzy_hideLoading;

+ (void)qyzy_showMsg:(NSString *)msg;
- (void)qyzy_showMsg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
