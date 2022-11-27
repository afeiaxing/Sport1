//
//  QYZYLiveChatModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveChatModel : NSObject
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign) NSInteger  type;
@property (nonatomic, strong) NSString * messageUId;
@end

NS_ASSUME_NONNULL_END
