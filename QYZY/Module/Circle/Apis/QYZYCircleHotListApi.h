//
//  QYZYCircleHotListApi.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCircleHotListApi : YTKRequest

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@end

NS_ASSUME_NONNULL_END
