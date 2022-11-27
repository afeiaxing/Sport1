//
//  QYZYCommendInputView.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MsgSendBlock)(NSString *msg);

@interface QYZYCommendInputView : UIView

@property (nonatomic, weak) UIView *parentView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, copy) MsgSendBlock msgSendBlock;

@property (nonatomic, copy) dispatch_block_t likeClickBlock;

@property (nonatomic, copy) dispatch_block_t collectClickBlock;

@property (nonatomic, copy) dispatch_block_t shareClickBlock;

@property (nonatomic, assign) BOOL isLike;

@property (nonatomic, assign) BOOL isFavorites;

@property (nonatomic, copy) NSString *commentCount;

- (void)updateInputViewWithStatus:(BOOL)isShow;

@end

NS_ASSUME_NONNULL_END
