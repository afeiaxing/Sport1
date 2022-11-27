//
//  QYZYUserModel.m
//  QYZY
//
//  Created by jsmaster on 9/30/22.
//

#import "QYZYUserModel.h"

@implementation QYZYUserModel


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
