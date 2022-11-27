//
//  QYZYappointmentApi.h
//  QYZY
//
//  Created by jspatches on 2022/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYappointmentApi : YTKRequest
@property (nonatomic ,strong)NSNumber  *leagueId;
@property (nonatomic ,assign)BOOL isBook;
@end

NS_ASSUME_NONNULL_END
