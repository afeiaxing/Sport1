//
//  QYZYMineModel.h
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMineModel : NSObject <NSSecureCoding>
@property (nonatomic ,copy) NSString *id;
@property (nonatomic ,copy) NSString *userId;
@property (nonatomic ,assign) NSInteger postCount;
@property (nonatomic ,assign) NSInteger articleCount;
@property (nonatomic ,assign) NSInteger dynamicCount;
@property (nonatomic ,assign) NSInteger informationCount;
@property (nonatomic ,assign) NSInteger commentAndReplyCount;
@property (nonatomic ,assign) NSInteger commentCount;
@property (nonatomic ,assign) NSInteger fansCount;
@property (nonatomic ,assign) NSInteger focusCount;
@property (nonatomic ,assign) NSInteger videoCount;
@property (nonatomic ,assign) NSInteger favoriteCount;
@property (nonatomic ,assign) NSInteger footprintCount;
@property (nonatomic ,copy) NSString *nickname;
@property (nonatomic ,copy) NSString *headImgUrl;
@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) NSString *personalDesc;
@property (nonatomic ,copy) NSString *background;
@property (nonatomic ,copy) NSString *createTime;
@property (nonatomic ,assign) NSInteger newsCommentCount;
@property (nonatomic ,assign) NSInteger newsFavoriteCount;
@property (nonatomic ,assign) NSInteger newsFootprintCount;
@property (nonatomic ,assign) BOOL     isAttention;
@property (nonatomic ,assign) BOOL     isAnchor;
@property (nonatomic ,assign) BOOL     isAuthor;
@property (nonatomic ,assign) BOOL     isEditor;
@property (nonatomic ,assign) BOOL     isMutualConcern;
@property (nonatomic ,assign) BOOL     isFans;
// 是否  超级管理员
@property (nonatomic ,assign) BOOL     isNewsAdmin;
// 1-被禁 0-正常
@property (nonatomic ,assign) BOOL     isNewsBanned;
// 主播 id
@property (nonatomic, copy) NSString *anchorId;
/// 是否是有料专家
@property (nonatomic ,assign) BOOL     isProphecyAuthor;
/// 主播等级
@property (nonatomic, assign) NSInteger level;
/// 主播等级icon
@property (nonatomic, copy) NSString *levelImg;
/// 贵族等级icon
@property (nonatomic, copy) NSString *nobiliyImg;
/// 贵族等级名称
@property (nonatomic, copy) NSString *nobiliyName;
/// 贵族等级
@property (nonatomic, copy) NSString *wealthLevel;
/// 财富等级icon
@property (nonatomic, copy) NSString *wealthLevelImg;


@end

NS_ASSUME_NONNULL_END
