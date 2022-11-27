//
//  QYZYIAPManager.h
//  QYZY
//
//  Created by jspollo on 2022/10/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger ,QYZYIAPPurchaseType) {
    QYZYIAPPurchaseSuccess = 0,             /// 购买成功
    QYZYIAPPurchaseFail = 1,                /// 购买失败
    QYZYIAPPurchaseCancel = 2,              /// 取消购买
    QYZYIAPPurchaseOrderCheckFail = 3,      /// 交易凭证验证失败
    QYZYIAPPurchaseOrderCheckSuccess = 4,   /// 交易凭证验证成功
    QYZYIAPPurchaseNotAllow = 5,            /// 不允许购买
    QYZYIAPPurchaseNotProduct = 6,          /// 没有该商品
};

typedef void(^QYZYIAPPurchaseBlock)(QYZYIAPPurchaseType type,NSData * _Nullable data);

@interface QYZYIAPManager : NSObject
+ (instancetype)shareInstace;
- (void)requestPurchaseWithProductId:(NSString *)productId completion:(QYZYIAPPurchaseBlock)completion;
@end

NS_ASSUME_NONNULL_END
