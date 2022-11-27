//
//  QYZYCommendReplyApi.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import "YTKBaseRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCommendReplyApi : YTKBaseRequest

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *orderField;

@end

NS_ASSUME_NONNULL_END
