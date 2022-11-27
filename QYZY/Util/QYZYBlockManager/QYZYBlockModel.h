//
//  QYZYBlockModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYBlockModel : NSObject<NSSecureCoding>
@property (nonatomic, assign) BOOL blockingByDeviceId;
@property (nonatomic, assign) BOOL blockingByIp;
@property (nonatomic, strong) NSArray *blockingLeagueIds;
@end

NS_ASSUME_NONNULL_END
