//
//  QYZYRankTableViewCell.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <UIKit/UIKit.h>
#import "QYZYRankModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface QYZYRankTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView *backView;

@property (nonatomic,strong)UILabel *rankLabel;

@property (nonatomic,strong)UIImageView *hadeImageView;

@property (nonatomic,strong)UILabel *nameLabel;

@property (nonatomic,strong)UILabel *fansLabel;

@property (nonatomic,strong)UIImageView *image;

@property (nonatomic,strong)UILabel *imageLabel;


- (void)updataUI:(QYZYRankModel *)model isDay:(BOOL)isDay;

@end

NS_ASSUME_NONNULL_END
