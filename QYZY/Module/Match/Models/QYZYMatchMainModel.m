//
//  QYZYMatchMainModel.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYMatchMainModel.h"

@implementation QYZYMatchMainModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"hostTeamHalfScore":@[@"hostTeamHalfScore",@"hostHalfScore"],
        @"guestTeamHalfScore":@[@"guestTeamHalfScore",@"guestHalfScore"],
    };
}
@end
