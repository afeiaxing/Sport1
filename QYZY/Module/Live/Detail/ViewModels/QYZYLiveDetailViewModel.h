//
//  QYZYLiveDetailViewModel.h
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import <Foundation/Foundation.h>
#import "QYZYLiveListModel.h"
#import "QYZYLiveRankModel.h"
#import "QYZYLiveChatFilterModel.h"
#import "QYZYChatGiftModel.h"
#import "QYZYAmountwithModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveDetailViewModel : NSObject
- (void)requestPullInfoWithAnchorId:(NSString *)anchorId completion:(void(^)(NSDictionary *pullInfo))completion;
- (void)requestBaseInfoWithAnchorId:(NSString *)anchorId completion:(void(^)(NSDictionary *baseInfo))completion;

- (void)requestMoreLiveWithAnchorId:(NSString *)anchorId completion:(void(^)(NSArray <QYZYLiveListModel *> *array))completion;
- (void)requestRankDataWithAnchorId:(NSString *)anchorId isDay:(BOOL)isDay completion:(void(^)(NSArray <QYZYLiveRankModel *> *array))completion;
- (void)requestFilterDataWithContent:(NSString *)content completion:(void(^)(QYZYLiveChatFilterModel *filterModel))completion;
- (void)requestGetGiftWithCompletion:(void(^)(NSArray <QYZYChatGiftModel *> *giftArray))completion;
- (void)requestSendGiftWithAnchorId:(NSString *)anchorId giftId:(NSString *)giftId chatId:(NSString *)chatId completion:(void(^)(NSString * msg))completion;
- (void)requestBalanceWithCompletion:(void(^)(QYZYAmountwithModel *model))completion;
@end

NS_ASSUME_NONNULL_END
