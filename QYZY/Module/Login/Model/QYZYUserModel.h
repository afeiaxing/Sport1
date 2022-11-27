//
//  QYZYUserModel.h
//  QYZY
//
//  Created by jsmaster on 9/30/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYUserModel : NSObject <NSSecureCoding>

@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, copy) NSString *userLevel;
@property(nonatomic, copy) NSString *ticket;
@property(nonatomic, copy) NSString *headImg;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *inviteUrl;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, strong) NSNumber *isRes;
@property(nonatomic, copy) NSString *agentName;
@property(nonatomic, copy) NSString *channelType;
@property(nonatomic, copy) NSString *anchorId;
@property(nonatomic, copy) NSString *token;
/// 余额（球钻）
@property (nonatomic, assign) double balance;

@end

NS_ASSUME_NONNULL_END
