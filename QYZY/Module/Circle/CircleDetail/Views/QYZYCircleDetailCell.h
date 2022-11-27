//
//  QYZYCircleDetailCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleContentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CircleDetailFollowBlock)(QYZYCircleContentModel *model);

@interface QYZYCircleDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet UIButton *followBtn;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong) QYZYCircleContentModel *model;

@property (nonatomic, copy) CircleDetailFollowBlock followBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaHeight;

@property (weak, nonatomic) IBOutlet UIButton *viewsView;

@property (weak, nonatomic) IBOutlet UIView *mediaView;
@end

NS_ASSUME_NONNULL_END
