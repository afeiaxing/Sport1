//
//  QYZYCircleContentModel.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCircleContentModel : NSObject

@property (nonatomic, copy) NSString *circleIcon;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *circleName;

@property (nonatomic, copy) NSString *commentStatus;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *createdDate;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *deletedFlag;

@property (nonatomic, copy) NSString *favprotesCount;

@property (nonatomic, copy) NSString *headImgUrl;

@property (nonatomic, copy) NSString *hotStatus;

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, assign) BOOL isAttention;

@property (nonatomic, assign) BOOL isFavorites;

@property (nonatomic, assign) BOOL isLike;

@property (nonatomic, copy) NSString *isReported;

@property (nonatomic, copy) NSString *labels;


@property (nonatomic, copy) NSString *lastModifiedDate;

@property (nonatomic, copy) NSString *latestPost;

@property (nonatomic, copy) NSString *likeCount;

@property (nonatomic, copy) NSString *mainPostId;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *pageViews;

@property (nonatomic, copy) NSString *parent;

@property (nonatomic, copy) NSString *postDate;


@property (nonatomic, strong) NSArray *postImgLists;

@property (nonatomic, copy) NSString *postType;

@property (nonatomic, strong) NSArray *postVOList;

@property (nonatomic, copy) NSString *recommendStatus;

@property (nonatomic, copy) NSString *replyId;

@property (nonatomic, copy) NSString *replyMainId;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *sharesCount;

@property (nonatomic, copy) NSString *sonNum;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, copy) NSString *vote;

@property (nonatomic, copy) NSString *webShareUrl;

@end

NS_ASSUME_NONNULL_END
