//
//  QYZYCommentInputView.h
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MsgSendBlock)(NSString *msg);

@interface QYZYCommentInputView : UIView

@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, copy) MsgSendBlock msgSendBlock;

- (void)updateInputViewWithStatus:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
