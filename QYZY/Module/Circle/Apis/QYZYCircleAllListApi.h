//
//  QYZYCircleAllList.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCircleAllListApi : YTKRequest

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, copy) NSString *sort;

@property (nonatomic, copy) NSString *circleId;

@property (nonatomic, copy) NSString *recommendStatus;

@end

NS_ASSUME_NONNULL_END
