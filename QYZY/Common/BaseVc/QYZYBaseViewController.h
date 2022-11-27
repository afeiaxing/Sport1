//
//  QYZYBaseViewController.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYBaseViewController : UIViewController

@property (nonatomic, strong ,nullable) UIView *leftItem;

@property (nonatomic, strong) UIView *rightItem;

// 子类有需要的话重写
- (void)backAction;

@end

NS_ASSUME_NONNULL_END
