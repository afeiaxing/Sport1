//
//  QYZYRankModel.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYRankModel : NSObject

/// 主播id
@property (nonatomic, copy) NSString *anchorId;
/// 人气
@property (nonatomic, copy)NSString *experience;
/// 头像图片
@property (nonatomic, copy) NSString *headImageUrl;
/// 昵称
@property (nonatomic, copy) NSString *nickname;
/// 是否已关注
@property (nonatomic, assign) BOOL fansType;
/// 主播等级
@property (nonatomic, assign) NSInteger level;
/// 主播等级图片
@property (nonatomic, copy) NSString *levelLogo;
// 是否开启大秀
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, copy) NSString *attentionUserStr;

/// 用户id
@property (nonatomic, copy) NSString *userId;
/// 壕气值
@property (nonatomic, copy) NSString *price;
/// 壕气等级
@property (nonatomic, assign) NSInteger wealthLevel;
/// 壕气等级图片
@property (nonatomic, copy) NSString *wealthLevelImg;

@end

NS_ASSUME_NONNULL_END
