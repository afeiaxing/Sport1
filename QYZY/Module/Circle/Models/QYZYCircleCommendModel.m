//
//  QYZYCircleCommendModel.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleCommendModel.h"

@implementation QYZYCircleCommendModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"parent" : [QYZYCircleContentModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"Id" : @"id"
    };
}

@end
