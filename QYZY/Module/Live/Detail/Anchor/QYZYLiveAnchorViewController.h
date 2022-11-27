//
//  QYZYLiveAnchorViewController.h
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYLiveDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveAnchorViewController : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,strong) QYZYLiveDetailModel *detailModel;
@property (nonatomic ,strong) NSString *anchorId;
@end

NS_ASSUME_NONNULL_END
