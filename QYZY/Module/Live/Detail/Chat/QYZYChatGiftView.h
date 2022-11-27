//
//  QYZYChatGiftView.h
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYChatGiftModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYChatGiftView : UIView
@property (nonatomic ,strong) NSArray <QYZYChatGiftModel *> *giftArray;
@property (nonatomic ,strong) void(^clickBlock)(QYZYChatGiftModel *giftModel);
@property (nonatomic ,strong) void(^chargeBlock)();
- (void)updateBalance;
@end

NS_ASSUME_NONNULL_END
