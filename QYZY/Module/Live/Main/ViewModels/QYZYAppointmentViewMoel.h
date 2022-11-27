//
//  QYZYAppointmentViewMoel.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <Foundation/Foundation.h>
#import "QYZYMyreservationApi.h"
#import "QYZYMyreserModel.h"
#import "QYZYMyattentionApi.h"
#import "QYZYMyattentionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYAppointmentViewMoel : NSObject
@property (nonatomic,strong)NSMutableArray *mutableArray;

- (void)requestGroupListWithCompletion:(void(^)(NSArray <QYZYMyreserModel *> *groupArray))completion;


- (void)requestAttentionCompletion:(void(^)(NSArray <QYZYMyattentionModel *> *groupArray))completion;


@end

NS_ASSUME_NONNULL_END
