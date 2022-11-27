//
//  QYZYBasketballOverViewCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import <UIKit/UIKit.h>
#import "QYZYBasketballScoreView.h"
#import "QYZYMatchMainModel.h"
#import "QYZYPeriodModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYBasketballOverViewCell : UITableViewCell

@property (nonatomic, strong) QYZYMatchMainModel *detailModel;

@property (nonatomic, strong) QYZYPeriodModel *periodModel;

@end

NS_ASSUME_NONNULL_END
