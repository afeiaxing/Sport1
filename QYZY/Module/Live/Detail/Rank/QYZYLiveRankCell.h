//
//  QYZYLiveRankCell.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <UIKit/UIKit.h>
#import "QYZYLiveRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveRankCell : UITableViewCell
@property (nonatomic ,strong) QYZYLiveRankModel *rankModel;
@property (nonatomic ,strong) void(^focusBlock)(QYZYLiveRankModel *model);
@end

NS_ASSUME_NONNULL_END
