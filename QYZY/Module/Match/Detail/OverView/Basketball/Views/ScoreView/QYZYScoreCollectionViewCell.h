//
//  QYZYScoreCollectionViewCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import <UIKit/UIKit.h>
#import "QYZYPeriodModel.h"
#import "QYZYMatchMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYScoreCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) QYZYPeriodModel *periodModel;

@property (nonatomic, strong) QYZYMatchMainModel *detailModel;

@end

NS_ASSUME_NONNULL_END
