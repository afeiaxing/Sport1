//
//  QYZYinfoModel.h
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class QYZYInfoImageModel ,QYZYInfoNewsLabelModel;


@interface QYZYinfoModel : NSObject<NSCoding>
@property (copy,   nonatomic) NSString *commentCount;
@property (copy,   nonatomic) NSString *ID;
@property (assign, nonatomic) NSInteger likeCount;
@property (assign, nonatomic) NSInteger mediaType;//0.新闻  1.视频

@property (nonatomic, assign) BOOL handleDate;//是否处理时间
@property (nonatomic, copy) NSString *createdDate;//创建时间;
@property (nonatomic, copy) NSString *createdDateBak;//创建时间;
@property (nonatomic, copy) NSString *footprintDate;//足迹时间;
@property (nonatomic, copy) NSString *categoryName;//属于资讯哪个模块

//展示类型
@property (assign, nonatomic) NSInteger showType;//（0: 正常, 1: 双图展示，2: 三图展示，3: 图集）
@property (  copy, nonatomic) NSString *imgUrl;//视频封面图
//@property (  copy, nonatomic) NSString *listImgUrl;//列表缩略图
@property (copy, nonatomic) NSString *newsId;
@property (copy, nonatomic) NSString *playUrl;//播放地址
@property (copy, nonatomic) NSString *preview;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *webShareUrl;
@property (nonatomic, assign) BOOL handlePicture;//是否处理图片
@property (nonatomic, copy) NSString *coverPicture; //封面图预览
@property (nonatomic, copy) NSString *coverPictureHd; //封面图高清

@property (strong, nonatomic) NSArray <QYZYInfoImageModel *> *newsImgs;//资讯图片列表


@property (nonatomic, strong) NSArray <NSString *> *preImgUrls;
@property (nonatomic, strong) NSArray <NSString *> *bigImgUrls;

@property (strong, nonatomic) NSArray <QYZYInfoNewsLabelModel *> *labels;//
@property (assign, nonatomic) NSInteger appShowType;//判断展示类型
@property (assign, nonatomic) NSInteger userId;
@property (assign, nonatomic) BOOL isDelete;//资讯是否删除， 0否 1是
@property (assign, nonatomic) BOOL isLike;//是否点赞
@property (assign, nonatomic) BOOL isTop;//是否置顶
@property (assign, nonatomic) BOOL gray;//是否置灰
@property (strong, nonatomic) QYZYinfoModel *user;
@property (nonatomic ,assign) NSInteger reviewStatus;//0 待审核 1 审核失败 2 审核通过
@end

@interface QYZYInfoImageModel : NSObject<NSCoding>

@property (copy, nonatomic) NSString *content;//内容
@property (copy, nonatomic) NSString *imgUrl;//图片
@property (copy, nonatomic) NSString *newsId;//资讯

@end

@interface QYZYInfoNewsLabelModel : NSObject<NSCoding>

@property (nonatomic ,copy) NSString *ID;
@property (nonatomic ,copy) NSString *lable;
@property (nonatomic ,copy) NSString *newsId;
@property (nonatomic ,copy) NSString *picUrl;
@property (nonatomic ,copy) NSString *referId;
@property (nonatomic ,assign) NSInteger type;

@end


NS_ASSUME_NONNULL_END
