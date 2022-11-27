//
//  QYZYLiveChatInputView.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveChatInputView : UIView

@property (nonatomic ,strong ,readonly) UITextView *textView;
@property (nonatomic ,strong) void(^commentBlock)(void);
@property (nonatomic ,strong) void(^giftBlock)(void);
- (void)updateStatusWithUserModel:(QYZYUserModel *)userModel;

@end

NS_ASSUME_NONNULL_END
