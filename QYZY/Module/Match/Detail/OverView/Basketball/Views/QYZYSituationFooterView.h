//
//  QYZYSituationFooterView.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import <UIKit/UIKit.h>
#import "QYZYMatchMainModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UpdateFooterHeightBlock)(CGFloat height);

@interface QYZYSituationFooterView : UIView

@property (nonatomic, strong) QYZYMatchMainModel *detailModel;

@property (nonatomic, copy) UpdateFooterHeightBlock updateFooterHeightBlock;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
