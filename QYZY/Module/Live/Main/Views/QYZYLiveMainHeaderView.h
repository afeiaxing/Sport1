//
//  QYZYLiveMainHeaderView.h
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import <UIKit/UIKit.h>
#import "QYZYLiveMainHotModel.h"
#import "QYZYLiveBannerModel.h"
#import <SDCycleScrollView.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveMainHeaderView : UIView
@property (nonatomic ,strong) NSArray<QYZYLiveMainHotModel *> * hotArray;
@property (nonatomic ,strong) NSArray<QYZYLiveBannerModel *> * bannerArray;
@property (nonatomic ,strong ,readonly) SDCycleScrollView *cycleView;
@end

NS_ASSUME_NONNULL_END
