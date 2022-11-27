//
//  QYZYNewsDetailNewsModel.h
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYNewsDetailNewsModel : NSObject
@property(nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, assign) BOOL isAttention;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) BOOL isFavorites;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *likeCount;
@property (nonatomic, copy) NSString *userId;


@end

NS_ASSUME_NONNULL_END
