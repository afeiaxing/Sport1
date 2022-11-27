//
//  QYZYMatchAnalyzeViewController.h
//  QYZY
//
//  Created by jspollo on 2022/10/14.
//

#import "QYZYBaseViewController.h"
#import "QYZYMatchMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchAnalyzeViewController : QYZYBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,strong) QYZYMatchMainModel *detailModel;

@end

NS_ASSUME_NONNULL_END
