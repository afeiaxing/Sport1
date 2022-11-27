//
//  QYZYResultAnchorCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import <UIKit/UIKit.h>
#import "QYZYSearchAnchorModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYResultAnchorCell : UITableViewCell

@property (nonatomic, strong) QYZYSearchAnchorModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

NS_ASSUME_NONNULL_END
