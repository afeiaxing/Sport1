//
//  NSArray+QYZYAdd.h
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (QYZYAdd)

/// 向当前的NSArray里找到的第一个找到的元素，可能为nil
/// @param block 筛选的block
- (id)xm_findFirstWithFilterBlock:(BOOL (^)(id obj))block;

@end

NS_ASSUME_NONNULL_END
