//
//  QYZYPopularListViewController.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYPopularListViewController : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,strong) NSString *anchorId;
@property (nonatomic ,assign) BOOL isDay;
@end

NS_ASSUME_NONNULL_END
