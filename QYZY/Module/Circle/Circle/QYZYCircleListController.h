//
//  QYZYCircleListController.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleContentModel.h"
#import "QYZYCircleListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CircleListGoToDetailPageBlock)(QYZYCircleContentModel *model);

typedef void(^CircleListGoToPersonPageBlock)(NSString *userId);

typedef void(^CircleListLikeTapBlock)(QYZYCircleContentModel *model);

@interface QYZYCircleListController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) CircleListGoToDetailPageBlock goToDetailPageBlock;

@property (nonatomic, copy) CircleListGoToPersonPageBlock personBlock;

@property (nonatomic, copy) CircleListLikeTapBlock likeBlock;

- (void)updateSegmentIndexWithModel:(QYZYCircleListModel *)model;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
