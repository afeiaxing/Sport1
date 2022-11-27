//
//  QYZYMatchListInfoDetailModel.m
//  QYZY
//
//  Created by jspatches on 2022/9/30.
//

#import "QYZYMatchListInfoDetailModel.h"

@implementation QYZYMatchListInfoDetailModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"leagueName":@[@"leagueName",@"tournamentName"]};
}
@end
