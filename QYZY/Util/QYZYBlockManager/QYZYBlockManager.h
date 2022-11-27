//
//  QYZYBlockManager.h
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import <Foundation/Foundation.h>
#import "QYZYBlockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYBlockManager : NSObject
@property (nonatomic ,strong) QYZYBlockModel *blockModel;
+ (instancetype)shareInstance;
+ (BOOL)isBlockedByLeagueId:(NSString *)leagueId;
- (void)requestData;
@end

NS_ASSUME_NONNULL_END
