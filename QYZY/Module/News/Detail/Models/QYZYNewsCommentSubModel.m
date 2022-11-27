//
//  QYZYNewsCommentSubModel.m
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import "QYZYNewsCommentSubModel.h"

@implementation QYZYNewsCommentSubModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"parent" : [QYZYNewsCommentSubParentModel class],
    };
}
@end
