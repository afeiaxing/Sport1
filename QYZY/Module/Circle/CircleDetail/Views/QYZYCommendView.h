//
//  QYZYCommendView.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleCommendModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCommendView : UIView

- (instancetype)initWithBottomArea:(CGFloat)safeBottom model:(QYZYCircleCommendModel *)model;

- (void)showView;

@end

NS_ASSUME_NONNULL_END
