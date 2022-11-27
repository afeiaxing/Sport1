//
//  QYZYFootballApi.h
//  QYZY
//
//  Created by jspatches on 2022/9/30.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYFootballApi : YTKRequest
@property (nonatomic,assign)NSInteger sportType;
@property (nonatomic,assign)NSString *date;

@end

NS_ASSUME_NONNULL_END
