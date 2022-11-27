//
//  NSArray+QYZYAdd.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "NSArray+QYZYAdd.h"

@implementation NSArray (QYZYAdd)

/// 向当前的NSArray里找到的第一个找到的元素，可能为nil
/// @param block 筛选的block
- (id)xm_findFirstWithFilterBlock:(BOOL (^)(id obj))block
{
    if (block) {
        for(id obj in self){
           BOOL result = block(obj);
           if(result){
               return obj;
           }
        }
    }
    return nil;
}

@end
