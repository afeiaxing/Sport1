//
//  QYZYPeriodModel.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYPeriodModel.h"

@implementation QYZYPeriodModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"Period1": [PeriodSubModel class],
        @"Period2": [PeriodSubModel class],
        @"Period3": [PeriodSubModel class],
        @"Period4": [PeriodSubModel class],
        @"Current": [PeriodSubModel class],
        @"Normaltime": [PeriodSubModel class],
    };
}

@end

@implementation PeriodSubModel

@end
