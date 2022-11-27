//
//  QYZYNewsDetailModel.m
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import "QYZYNewsDetailModel.h"
#import "QYZYNewsDetailNewsModel.h"
#import "QYZYNewsDetailCurrentNewsModel.h"

@implementation QYZYNewsDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"news" : [QYZYNewsDetailNewsModel class],
        @"currentNews" : [QYZYNewsDetailCurrentNewsModel class]
    };
}

@end
