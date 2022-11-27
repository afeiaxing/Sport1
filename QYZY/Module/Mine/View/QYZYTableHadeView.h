//
//  QYZYTableHadeView.h
//  QYZY
//
//  Created by jspatches on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYPhotoManager.h"
#import "QYZYMineModel.h"
#import "QYZYAmountwithModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^QYZYHadeViewCellBookBlock)(void);
typedef void(^QYZYHadepushBlock)(void);
typedef void(^QYZYHadeViewupBlock)(void);
typedef void(^QYZYHadeViewSetupBlock)(void);
typedef void(^QYZYHadeViewTopUpBlock)(void);

@interface QYZYTableHadeView : UIView
@property (nonatomic,strong)UIButton *setButton;
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIImageView *hadeImageView;
@property (nonatomic,strong)UILabel *namelabel;
@property (nonatomic,strong)UILabel *signature;
@property (nonatomic,strong)UIView *leveView;
@property (nonatomic,strong)UILabel *level;
@property (nonatomic,strong)UIImageView *leveImageView;
@property (nonatomic,strong)UIView *upView;
@property (nonatomic,strong)UILabel *uplabel;
@property (nonatomic,strong)UIImageView *upImageView;
@property (nonatomic,strong)UILabel *focusLabel;
@property (nonatomic,strong)UILabel *focusnumber;
@property (nonatomic,strong)UILabel *fansLabel;
@property (nonatomic,strong)UILabel *fansLabelnumber;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *beansImageView;
@property (nonatomic,strong)UILabel *beansLabel;
@property (nonatomic,strong)UIButton *chargeButton;
@property (nonatomic,strong)UIButton *pushImageView;
@property (nonatomic, strong)QYZYPhotoManager *photoManager;
- (void)updataUI:(QYZYMineModel *)model;
- (void)updataAmount:(QYZYAmountwithModel *)model;
//点击登录
@property (nonatomic, copy) QYZYHadeViewCellBookBlock actionBlock;
//点击个人主页
@property (nonatomic, copy) QYZYHadepushBlock pushBlock;
//点击粉丝关注
@property (nonatomic, copy) QYZYHadeViewupBlock upBlock;
//设置
@property (nonatomic, copy) QYZYHadeViewSetupBlock setupBlock;
//充值
@property (nonatomic, copy) QYZYHadeViewTopUpBlock topupBlock;

- (void)exit;

@end

NS_ASSUME_NONNULL_END
