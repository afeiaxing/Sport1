//
//  QYZYCircleDetailApi.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCircleDetailApi : YTKRequest

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *postId;

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *orderField;


@end

NS_ASSUME_NONNULL_END
