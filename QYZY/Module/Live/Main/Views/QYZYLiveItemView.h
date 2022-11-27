//
//  QYZYLiveItemView.h
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import <UIKit/UIKit.h>
#import "QYZYLiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveItemView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic ,strong) QYZYLiveListModel *listModel;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;

@end

NS_ASSUME_NONNULL_END
