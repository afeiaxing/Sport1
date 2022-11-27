//
//  QYZYSetNullTool.m
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import "QYZYSetNullTool.h"

@implementation QYZYSetNullTool

// 类型识别:将所有的NSNull类型转化成@""
+ (id)changeNullTypeWithValue:(id)value {
    if ([value isKindOfClass:[NSDictionary class]]) {
        return [self nullWithDict:value];
    } else if ([value isKindOfClass:[NSArray class]]) {
        return [self nullWithArray:value];
    } else if ([value isKindOfClass:[NSString class]]) {
        if ([value isEqualToString:@"null"] || [value isEqualToString:@"<null>"] || [value isEqualToString:@"(null)"] || [value isEqualToString:@"NULL"]) {
            return @"";
        } else {
            return value;
        }
    } else if ([value isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        return value;
    }
}

/// 将NSDictionary中的Null类型的项目转化成@""
+ (NSDictionary *)nullWithDict:(NSDictionary *)dict {
    NSArray * keyArray = [dict allKeys];
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc]init];
    [keyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id objValue = [dict objectForKey:obj];
        objValue = [self changeNullTypeWithValue:objValue];
        [resultDict setObject:objValue forKey:keyArray[idx]];
    }];
    return resultDict;
}

/// 将NSArray中的Null类型的项目转化成@""
+ (NSArray *)nullWithArray:(NSArray *)array {
    NSMutableArray * resultArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = [self changeNullTypeWithValue:obj];
        [resultArray addObject:obj];
    }];
    return resultArray;
}


@end
