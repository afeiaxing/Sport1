//
//  QYZYNewsCommentSubApi.h
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYNewsCommentSubApi : YTKRequest

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *commentId;

@end

NS_ASSUME_NONNULL_END
