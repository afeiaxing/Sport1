//
//  QYZYPlayerDataController.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYBaseViewController.h"
#import "QYZYMatchMainModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^UpdateHeightBlock)(CGFloat height);

@interface QYZYPlayerDataController : QYZYBaseViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, strong) QYZYMatchMainModel *detailModel;

@property (nonatomic, copy) UpdateHeightBlock updateHeightBlock;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
