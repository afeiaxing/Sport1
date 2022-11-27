//
//  QYZYPersonalHadeView.h
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import <UIKit/UIKit.h>
#import "QYZYMineModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^QYZYHadeViewBackButtonBlock)(void);

@interface QYZYPersonalHadeView : UIView
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UILabel *numberfans;
@property (nonatomic,strong)UILabel *numberfocus;
@property (nonatomic,strong)UILabel *fanslabel;
@property (nonatomic,strong)UILabel *focuslabel;
@property (nonatomic,strong)UIView *lineView;
@property (nonatomic,strong)UIView *hadeBackView;
@property (nonatomic,strong)UIImageView *hadeImageView;
@property (nonatomic,strong)UILabel *namelabel;
@property (nonatomic,strong)UILabel *signature;
@property (nonatomic,strong)UIButton *livstudioButton;
@property (nonatomic,strong)UIButton *focusButton;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic, copy) QYZYHadeViewBackButtonBlock backBlock;
- (void)updataUI:(QYZYMineModel *)model;

- (void)updaFocus:(BOOL)isFocus;

@end

NS_ASSUME_NONNULL_END
