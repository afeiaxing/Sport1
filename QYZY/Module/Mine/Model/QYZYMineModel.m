//
//  QYZYMineModel.m
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import "QYZYMineModel.h"

@implementation QYZYMineModel

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [self yy_modelEncodeWithCoder:coder];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    return [self yy_modelInitWithCoder:coder];
}

- (NSString *)description {
    return [self yy_modelToJSONString];
}

@end
