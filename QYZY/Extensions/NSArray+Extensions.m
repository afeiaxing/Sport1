//
//  NSArray+Extensions.m
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import "NSArray+Extensions.h"

@implementation NSArray (Extensions)

- (id)qyzy_findFirstWithFilterBlock:(BOOL (^)(id obj))block
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

- (NSArray *)qyzy_filterByBlock:(BOOL (^)(id obj))block {
    if (block) {
        NSMutableArray *array = [NSMutableArray array];
        for(id obj in self){
           BOOL result = block(obj);
           if(result){
               [array addObject:obj];
           }
        }
        return [array copy];
    } else {
        return self;
    }
}

+ (NSMutableArray *)qyzy_arrayWithCount:(NSInteger)count fillBlock:(id(^)(NSInteger idx))block {
    NSMutableArray *arrayM = [NSMutableArray array];
    if(block && count>0){
        for(NSInteger i=0;i<count;i++){
            id data = block(i);
            if(data){
                [arrayM addObject:data];
            }
        }
    }
    return arrayM;
}

@end
