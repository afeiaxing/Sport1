//
//  QYZYMyattentionModel.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMyattentionModel : NSObject<NSCoding>
// 主键
@property (nonatomic, copy) NSString *uuid;
// 被关注用户ID
@property (nonatomic, copy) NSString *userId;
// 当前登陆用户ID
@property (nonatomic, copy) NSString *focusUserId;
// 0 未设置 1 男 2 女
@property (nonatomic, strong) NSNumber *sex;
// 用户头像
@property (nonatomic, copy) NSString *headImgUrl;
// 用户昵称
@property (nonatomic, copy) NSString *nickname;
// 用户简介
@property (nonatomic, copy) NSString *personalDesc;
// 当前连红数
@property (nonatomic, assign) NSInteger continuousRed;
// 关注状态
@property (nonatomic, assign) BOOL isAttention;
// 新发表
@property (nonatomic, assign) NSInteger newCount;
// 平台标签 0.默认 1.媒体大咖 2.职业球员 3.资深玩家
@property (nonatomic, assign) NSInteger platformLabel;
// 创作身份 0.初级专家 1.中级专家 2.高级专家 3.资深专家
@property (nonatomic, assign) NSInteger levelLabel;
// 周推总荐场次
@property (nonatomic, assign) NSInteger weekCount;
// 周胜场次
@property (nonatomic, assign) NSInteger weekWinCount;
// 周回报率
@property (nonatomic, copy) NSString *weekResponseRate;
// 有料数
@property (nonatomic, strong) NSNumber *informationCount;
// 月回报率
@property (nonatomic, strong) NSNumber *monthResponseRate;
// 总共负数
@property (nonatomic, strong) NSNumber *negativeNumber;
// 资讯评论数
@property (nonatomic, strong) NSNumber *newsCommentCount;
// 资讯收藏数
@property (nonatomic, strong) NSNumber *newsFavoriteCount;
// 资讯足迹数
@property (nonatomic, strong) NSNumber *newsFootprintCount;
// 发帖数
@property (nonatomic, strong) NSNumber *postCount;
// 季回报率
@property (nonatomic, strong) NSNumber *quarterResponseRate;
// 总共红数
@property (nonatomic, strong) NSNumber *redNumber;

// 主播ID
@property (nonatomic, copy) NSString *anchorId;
// 文章数
@property (nonatomic, strong) NSNumber *articleCount;
// 背景图
@property (nonatomic, copy) NSString *background;
// 帖子评论数
@property (nonatomic, strong) NSNumber *commentCount;
// 主播等级
@property (nonatomic, strong) NSNumber *level;
// 主播等级图片标识
@property (nonatomic, copy) NSString *levelImg;
// 1直播中0結束
@property (nonatomic, assign) BOOL liveStatus;
// 粉丝数
@property (nonatomic, strong) NSNumber *fansCount;
// 关注数
@property (nonatomic, strong) NSNumber *focusCount;
// 直播回放数量
@property (nonatomic, strong) NSNumber *numberOfLivePlaybacks;
// 播放量
@property (nonatomic, strong) NSNumber * playBackQuantity;
// 视频数
@property (nonatomic, copy) NSString *videoCount;

// 注册时间
@property (nonatomic, copy) NSString *createTime;
// 动态数
@property (nonatomic, strong) NSNumber *dynamicCount;
// 帖子收藏数
@property (nonatomic, strong) NSNumber *favoriteCount;
// 足迹数
@property (nonatomic, strong) NSNumber *footprintCount;

// 是否主播
@property (nonatomic, assign) BOOL isAnchor;
// 是否作者
@property (nonatomic, assign) BOOL isAuthor;
// 是否特约编辑
@property (nonatomic, assign) BOOL isEditor;
// 是否是我的粉丝
@property (nonatomic, assign) BOOL isFans;
// 是否互相关注
@property (nonatomic, assign) BOOL isMutualConcern;
// 是否是社区超管
@property (nonatomic, assign) BOOL isNewsAdmin;
// 是否是有料专家 1-是，0-否
@property (nonatomic, strong) NSNumber *isProphecyAuthor;

@end

NS_ASSUME_NONNULL_END
