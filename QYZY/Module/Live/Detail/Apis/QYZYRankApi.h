//
//  QYZYRankApi.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYRankApi : YTKRequest
@property (nonatomic ,assign) BOOL isDay;
@property (nonatomic ,strong) NSNumber  *type;
@end

NS_ASSUME_NONNULL_END
