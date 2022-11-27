//
//  QYZYMyattentionTableViewCell.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <UIKit/UIKit.h>
#import "QYZYMyattentionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QYZYMyattentionTableViewCell : UITableViewCell

@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UIImageView *hadeImageView;

@property (nonatomic,strong)UIImageView *liveImageView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *fansLabel;

@property (nonatomic,strong)UIButton *focusButton;
@property (nonatomic,strong)QYZYMyattentionModel *model;
@property (nonatomic ,strong) void(^focusBlock)(QYZYMyattentionModel *model);

- (void)updataUI:(QYZYMyattentionModel *)model;

@end

NS_ASSUME_NONNULL_END
