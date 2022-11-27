//
//  QYZYLiveMainViewModel.h
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import <Foundation/Foundation.h>
#import "QYZYLiveMainGroupModel.h"
#import "QYZYLiveMainHotModel.h"
#import "QYZYLiveListModel.h"
#import "QYZYLiveBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveMainViewModel : NSObject

- (void)requestGroupListWithCompletion:(void(^)(NSArray <QYZYLiveMainGroupModel *> *groupArray ,NSString *msg))completion;
- (void)requestHotListWithCompletion:(void (^)(NSArray<QYZYLiveMainHotModel *> * hotArray, NSString * msg))completion;
- (void)requestLiveListWithLiveGroupId:(NSString *)liveGroupId completion:(void (^)(NSArray<QYZYLiveListModel *> * liveArray, NSString * msg))completion;
- (void)requestLiveBannerWithCompletion:(void (^)(NSArray<QYZYLiveBannerModel *> * bannerArray, NSString * msg))completion;

@end

NS_ASSUME_NONNULL_END
