//
//  QYZYHotViewController.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleContentModel.h"
#import "QYZYCircleListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GoToDetailPageBlock)(QYZYCircleContentModel *model);
typedef void(^HotViewCircleTapBlock)(QYZYCircleListModel *model);
typedef void(^HotViewGoToPersonPageBlock)(NSString *userId);
typedef void(^HotViewCircleLikeTapBlock)(QYZYCircleContentModel *model);

@interface QYZYHotViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) GoToDetailPageBlock goToDetailPageBlock;

@property (nonatomic, copy) HotViewCircleTapBlock circleTapBlock;

@property (nonatomic, copy) HotViewGoToPersonPageBlock personBlock;

@property (nonatomic, copy) HotViewCircleLikeTapBlock likeBlock;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
