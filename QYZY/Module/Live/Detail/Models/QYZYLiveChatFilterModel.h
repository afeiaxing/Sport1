//
//  QYZYLiveChatFilterModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveChatFilterModel : NSObject
@property (nonatomic,   copy) NSString *content;
@property (nonatomic,   copy) NSString *nickname;
@property (nonatomic,   copy) NSString *sign;
@property (nonatomic,   copy) NSString *userId;
@property (nonatomic,   copy) NSString *pushTime;
@property (nonatomic, assign) BOOL success;
@property(nonatomic, copy) NSString *desc;
@end

NS_ASSUME_NONNULL_END
