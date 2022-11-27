//
//  QYZYCommendNewsView.h
//  QYZY
//
//  Created by jsgordong on 2022/10/3.
//

#import <UIKit/UIKit.h>
#import "QYZYNewsCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCommendNewsView : UIView

- (instancetype)initWithBottomArea:(CGFloat)safeBottom commentId:(NSString *)commentId newsId:(NSString *)newsId;

- (void)showView;

@end


NS_ASSUME_NONNULL_END
