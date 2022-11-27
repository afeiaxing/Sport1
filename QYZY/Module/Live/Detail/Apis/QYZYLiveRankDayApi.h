//
//  QYZYLiveRankDayApi.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveRankDayApi : YTKRequest
@property (nonatomic ,strong) NSString *anchorId;
@property (nonatomic ,assign) BOOL isDay;
@end

NS_ASSUME_NONNULL_END
