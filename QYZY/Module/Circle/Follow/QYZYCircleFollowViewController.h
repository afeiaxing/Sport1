//
//  QYZYCircleFollowViewController.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleContentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^FollowGoToDetailPageBlock)(QYZYCircleContentModel *model);

typedef void(^FollowGoToPersonPageBlock)(NSString *userId);

typedef void(^FollowCircleLikeTapBlock)(QYZYCircleContentModel *model);

@interface QYZYCircleFollowViewController : UIViewController<JXCategoryListContentViewDelegate>

@property (nonatomic, copy) FollowGoToDetailPageBlock goToDetailPageBlock;

@property (nonatomic, copy) FollowGoToPersonPageBlock personBlock;

@property (nonatomic, copy) FollowCircleLikeTapBlock likeBlock;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
