//
//  QYZYMatchDetailApi.h
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchDetailApi : YTKRequest
@property (nonatomic, strong) NSString *matchId;
@end

NS_ASSUME_NONNULL_END
