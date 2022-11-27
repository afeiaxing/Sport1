//
//  QYZYCircleChildrenController.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleListModel.h"
#import "QYZYCircleContentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CircleChildLikeTapBlock)(QYZYCircleContentModel *model);

typedef void(^CircleGoToPersonPageBlock)(NSString *userId);

typedef void(^CircleGoToDetailPageBlock)(QYZYCircleContentModel *model);

@interface QYZYCircleChildrenController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) CircleGoToDetailPageBlock goToDetailPageBlock;

@property (nonatomic, copy) CircleGoToPersonPageBlock personBlock;

@property (nonatomic, copy) CircleChildLikeTapBlock likeBlock;

- (instancetype)initWithModel:(QYZYCircleListModel *)model;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
