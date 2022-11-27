//
//  QYZYPeriodModel.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class PeriodSubModel;

@interface QYZYPeriodModel : NSObject

@property (nonatomic, copy) NSString *periodType;

@property (nonatomic, strong) PeriodSubModel *Period1;

@property (nonatomic, strong) PeriodSubModel *Period2;

@property (nonatomic, strong) PeriodSubModel *Period3;

@property (nonatomic, strong) PeriodSubModel *Period4;

@property (nonatomic, strong) PeriodSubModel *Current;

@property (nonatomic, strong) PeriodSubModel *Normaltime;

@end

@interface PeriodSubModel : NSObject

@property (nonatomic, copy) NSString *matchId;

@property (nonatomic, copy) NSString *periodType;

@property (nonatomic, copy) NSString *side;

@property (nonatomic, copy) NSString *team1;

@property (nonatomic, copy) NSString *team2;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *typeCode;

@property (nonatomic, copy) NSString *typeId;

@end



NS_ASSUME_NONNULL_END
