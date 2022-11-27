//
//  QYZYReportModel.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import "QYZYReportModel.h"

@implementation QYZYReportModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"reasonId" : @"id",
    };
}

@end
