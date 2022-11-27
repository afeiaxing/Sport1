//
//  QYZYBlockModel.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYBlockModel.h"

@implementation QYZYBlockModel
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [self yy_modelEncodeWithCoder:coder];
}
- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    return [self yy_modelInitWithCoder:coder];
}
+ (BOOL)supportsSecureCoding {
    return YES;
}
@end
