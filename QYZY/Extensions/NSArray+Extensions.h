//
//  NSArray+Extensions.h
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Extensions)

- (id)qyzy_findFirstWithFilterBlock:(BOOL (^)(id obj))block;
- (NSArray *)qyzy_filterByBlock:(BOOL (^)(id obj))block;
+ (NSMutableArray *)qyzy_arrayWithCount:(NSInteger)count fillBlock:(id(^)(NSInteger idx))block;

@end

NS_ASSUME_NONNULL_END
