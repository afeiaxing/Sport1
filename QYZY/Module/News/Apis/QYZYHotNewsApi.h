//
//  QYZYHotNewsApi.h
//  QYZY
//
//  Created by jsmaster on 10/1/22.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYHotNewsApi : YTKRequest

@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;

@end

NS_ASSUME_NONNULL_END
