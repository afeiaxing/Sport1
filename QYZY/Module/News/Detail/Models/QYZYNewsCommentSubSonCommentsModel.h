//
//  QYZYNewsCommentSubSonCommentsModel.h
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYNewsCommentSubSonCommentsModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImgUrl;
@property (nonatomic, copy) NSString *createdDate;
@property (nonatomic, copy) NSString *replyId;
@property (nonatomic, copy) NSString *likeCount;
@end

NS_ASSUME_NONNULL_END
