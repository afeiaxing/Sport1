//
//  QYZYPiecewiseTableViewCell.h
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^QYZYTableViewnCellButtonBlock)(UIButton *button);

@interface QYZYPiecewiseTableViewCell : UITableViewCell

@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIButton *postButton;
@property (nonatomic,strong)UIButton *articleButton;
@property (nonatomic,strong)UIView *lineView2;
@property (nonatomic,strong)UIView *boomLineView;


@property (nonatomic,copy) QYZYTableViewnCellButtonBlock buttonBlock;

- (void)ispost:(BOOL)post;
@end

NS_ASSUME_NONNULL_END
