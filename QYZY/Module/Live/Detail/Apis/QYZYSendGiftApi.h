//
//  QYZYSendGiftApi.h
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYSendGiftApi : YTKRequest
@property (nonatomic ,strong) NSString *giftId;
@property (nonatomic ,strong) NSString *anchorId;
@property (nonatomic ,strong) NSString *chatId;
@end

NS_ASSUME_NONNULL_END
