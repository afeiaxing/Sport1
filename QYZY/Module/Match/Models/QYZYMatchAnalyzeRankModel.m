//
//  QYZYMatchAnalyzeRankModel.m
//  QYZY
//
//  Created by jspollo on 2022/10/25.
//

#import "QYZYMatchAnalyzeRankModel.h"

@implementation QYZYMatchAnalyzeRankSubModel

@end

@implementation QYZYMatchAnalyzeRankModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"all": [QYZYMatchAnalyzeRankSubModel class],
        @"host": [QYZYMatchAnalyzeRankSubModel class],
        @"guest": [QYZYMatchAnalyzeRankSubModel class],
    };
}
@end
