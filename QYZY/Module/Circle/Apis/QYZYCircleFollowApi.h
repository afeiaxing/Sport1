//
//  QYZYCircleFollowApi.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCircleFollowApi : YTKRequest

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@end

NS_ASSUME_NONNULL_END
