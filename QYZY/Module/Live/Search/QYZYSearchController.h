//
//  QYZYSearchController.h
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "QYZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GoToLivePageBlock)(NSString *anchorId);

@interface QYZYSearchController : QYZYBaseViewController

@property (nonatomic, copy) GoToLivePageBlock goToLivePageBlock;

@end

NS_ASSUME_NONNULL_END
