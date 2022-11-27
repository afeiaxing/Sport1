//
//  QYZYTotalNewsApi.h
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYTotalNewsApi : YTKRequest
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger mediaType;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *sportType;
@end

NS_ASSUME_NONNULL_END
