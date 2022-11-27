//
//  QYZYLiveDetailModel.h
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveDetailModel : NSObject
@property (nonatomic, strong) NSString *leagueId;
@property (nonatomic, strong) NSString * animUrl;
@property (nonatomic, assign) BOOL showAnimation;
@property (nonatomic, strong) NSDictionary *playAddr;
@property (nonatomic, strong) NSNumber * isRobot;
@property (nonatomic, strong) NSNumber * isShow;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSString *liveTitle;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *fans;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSString *profile;
@property (nonatomic, strong) NSNumber * focusStatus;//0未关注1已关注
@property (nonatomic, copy) NSString *stb;
@end

NS_ASSUME_NONNULL_END
