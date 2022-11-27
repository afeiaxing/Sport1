//
//  QYZYAnalyzeIntegralApi.h
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYAnalyzeIntegralApi : YTKRequest
@property (nonatomic, strong) NSString *matchId;
@property (nonatomic ,assign) BOOL isBasket; /// 是否篮球，默认否
@end

NS_ASSUME_NONNULL_END
