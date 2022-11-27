//
//  QYZYLiveCell.h
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import <UIKit/UIKit.h>
#import "QYZYLiveListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveCell : UICollectionViewCell
@property (nonatomic ,strong) QYZYLiveListModel *listModel;
@end

NS_ASSUME_NONNULL_END
