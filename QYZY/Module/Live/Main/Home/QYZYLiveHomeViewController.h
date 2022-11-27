//
//  QYZYLiveHomeViewController.h
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveHomeViewController : UIViewController<JXCategoryListContentViewDelegate ,JXPagerViewListViewDelegate>
@property (nonatomic ,strong) NSString *liveGroupId;
@end

NS_ASSUME_NONNULL_END
