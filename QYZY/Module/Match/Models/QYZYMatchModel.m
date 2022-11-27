//
//  QYZYMatchModel.m
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import "QYZYMatchModel.h"

@implementation QYZYMatchDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"hostHalfScore":@[@"hostHalfScore",@"hostTeamHalfScore"],
        @"guestHalfScore":@[@"guestHalfScore",@"guestTeamHalfScore"],
    };
}
@end

@implementation QYZYSubMatchModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"matches": [QYZYMatchDetailModel class],
    };
}
@end

@implementation QYZYMatchModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"finished":[QYZYSubMatchModel class],
        @"going":[QYZYSubMatchModel class],
        @"uncoming":[QYZYSubMatchModel class],
        @"unknown":[QYZYSubMatchModel class],
    };
}
@end
