//
//  UILabel+XMUtils.h
//  XMSport
//
//  Created by jsekko on 2020/12/7.
//  Copyright © 2020 XMSport. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (XMUtils)

/**
 *  UILabel缩进
 *  @param line  从第几行缩进
 *  @param indent   与头部的距离
 */
- (void)indentationWithLine:(NSInteger)line headIndent:(CGFloat)indent;

@end

NS_ASSUME_NONNULL_END
