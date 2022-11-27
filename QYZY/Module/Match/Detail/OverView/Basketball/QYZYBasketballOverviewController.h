//
//  QYZYBasketballOverviewController.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYBaseViewController.h"
#import "QYZYMatchMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYBasketballOverviewController : QYZYBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,strong) QYZYMatchMainModel *detailModel;
@property (nonatomic ,strong) NSString *matchId;

@end

NS_ASSUME_NONNULL_END
