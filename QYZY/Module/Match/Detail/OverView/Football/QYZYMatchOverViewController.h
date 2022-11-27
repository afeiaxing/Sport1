//
//  QYZYMatchOverViewController.h
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYBaseViewController.h"
#import "QYZYMatchMainModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchOverViewController : QYZYBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,strong) QYZYMatchMainModel *detailModel;
@property (nonatomic ,strong) NSString *matchId;
@end

NS_ASSUME_NONNULL_END
