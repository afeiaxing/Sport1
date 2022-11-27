//
//  QYZYFootballViewModel.h
//  QYZY
//
//  Created by jspatches on 2022/9/30.
//

#import <Foundation/Foundation.h>
#import "QYZYFootballApi.h"
#import "QYZYMatchListInfoDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYFootballViewModel : NSObject
@property (nonatomic,strong)NSMutableArray *mutableArray;
@property(nonatomic,strong)NSNumber  *leagueId;//预约的比赛ID

- (void)requestGroupListWithCompletion:(void(^)(NSArray <QYZYMatchListInfoDetailModel *> *groupArray))completion;

- (void)requestappointmenttothegameCompletion:(void(^)(NSString * _Nullable msg))completion isBook:(BOOL)isBook;
@property (nonatomic,assign)NSInteger sportType;//请求赛程数据用到的type

@end

NS_ASSUME_NONNULL_END
