//
//  QYZYQaModel.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYQaModel.h"

@implementation QYZYQaModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"answerList" : [QYZYQARouModel class]};
}

@end
