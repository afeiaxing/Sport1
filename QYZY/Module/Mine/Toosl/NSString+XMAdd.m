
//
//  NSString+XMAdd.m
//  XMSportDevelop
//
//  Created by fly on 23/07/2019.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import "NSString+XMAdd.h"

@implementation NSString (XMAdd)

- (BOOL)xm_isEmpty {
    if (!self) return YES;
    if (![self isKindOfClass:[NSString class]]) return YES;
    return self.length == 0;
}

// 读取本地JSON文件
- (NSDictionary *)xm_readLocalJSONFile {
    if (!self) return nil;
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:self ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

/**
 *  转为json对象，返回NSDictionary or NSArray or nil
 *  @return NSDictionary or NSArray
 */
- (id)xm_JSONObject {
    if ([self xm_isEmpty]) return nil;
    NSError *error = nil;
    NSData *responseData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    if(error) return nil;
    return object;
}

@end
