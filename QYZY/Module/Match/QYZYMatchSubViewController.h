//
//  QYZYMatchSubViewController.h
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import "QYZYBaseViewController.h"
#import "QYZYMatchModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchSubViewController : QYZYBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,strong) NSArray <QYZYMatchDetailModel *> *matches;
@property (nonatomic ,strong) void(^requestBlock)(void);
- (void)endRefresh;
@end

NS_ASSUME_NONNULL_END
