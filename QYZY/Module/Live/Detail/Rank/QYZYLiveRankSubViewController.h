//
//  QYZYLiveRankSubViewController.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveRankSubViewController : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,strong) NSString *anchorId;
@property (nonatomic ,assign) BOOL isDay;
@end

NS_ASSUME_NONNULL_END
