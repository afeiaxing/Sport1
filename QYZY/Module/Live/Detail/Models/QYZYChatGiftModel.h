//
//  QYZYChatGiftModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYChatGiftModel : NSObject
@property (nonatomic, strong) NSString * giftId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * type;/// 只取2
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString * imgUrl;
@property (nonatomic, assign) BOOL isClick;
@end

NS_ASSUME_NONNULL_END
