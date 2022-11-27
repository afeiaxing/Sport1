//
//  QYZYResultLiveRoomCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import <UIKit/UIKit.h>
#import "QYZYSearchLiveModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ActionBlock)(NSString *anchorId);

@interface QYZYResultLiveRoomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;

@property (nonatomic, strong) NSMutableArray *models;

@property (weak, nonatomic) IBOutlet UILabel *leftTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *rightTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightNameLabel;

@property (weak, nonatomic) IBOutlet UIView *leftContainer;

@property (weak, nonatomic) IBOutlet UIView *rightContainer;

@property (nonatomic, copy) ActionBlock block;

@end

NS_ASSUME_NONNULL_END
