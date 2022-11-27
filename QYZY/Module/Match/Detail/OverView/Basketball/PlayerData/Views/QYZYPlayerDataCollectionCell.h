//
//  QYZYPlayerDataCollectionCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/25.
//

#import <UIKit/UIKit.h>
#import "QYZYPlayerDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYPlayerDataCollectionCell : UICollectionViewCell

@property (nonatomic, strong) QYZYPlayerDataModel *model;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
