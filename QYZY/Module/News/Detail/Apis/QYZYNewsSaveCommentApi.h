//
//  QYZYNewsSaveCommentApi.h
//  QYZY
//
//  Created by jsgordong on 2022/10/3.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYNewsSaveCommentApi : YTKRequest

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *newsId;

@property (nonatomic, copy) NSString *replyId;


@end

NS_ASSUME_NONNULL_END
