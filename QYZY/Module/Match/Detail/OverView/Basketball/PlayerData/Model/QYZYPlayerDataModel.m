//
//  QYZYPlayerDataModel.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYPlayerDataModel.h"

@implementation QYZYPlayerDataModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"playerStats": [QYZYPlayerInfoModel class],
    };
}

@end
