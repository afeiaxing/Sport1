//
//  NSString+XMAdd.h
//  XMSportDevelop
//
//  Created by fly on 23/07/2019.
//  Copyright © 2019 XMSport. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XMAdd)

/// 判断字符串是否为空
- (BOOL)xm_isEmpty;

/// 读取本地JSON文件
- (NSDictionary *)xm_readLocalJSONFile;

/**
 *  string转json对象
 *  @return NSDictionary | NSArray | nil
 */
- (id)xm_JSONObject;

@end

NS_ASSUME_NONNULL_END

