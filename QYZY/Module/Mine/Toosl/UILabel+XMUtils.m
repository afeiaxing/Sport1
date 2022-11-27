//
//  UILabel+XMUtils.m
//  XMSport
//
//  Created by jsekko on 2020/12/7.
//  Copyright © 2020 XMSport. All rights reserved.
//

#import "UILabel+XMUtils.h"

@implementation UILabel (XMUtils)

/// 缩进
- (void)indentationWithLine:(NSInteger)line headIndent:(CGFloat)indent {
    NSString *text = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    
    //第一行头缩进
    [paragraphStyle setFirstLineHeadIndent:line];
    //头部缩进
    [paragraphStyle setHeadIndent:indent];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [self setAttributedText:attributedString];
    
    [self setLineBreakMode:NSLineBreakByTruncatingTail];
    
    CGRect dlRect = self.frame;
    [self sizeToFit];
    CGRect dlRectNew = self.frame;
    if(dlRectNew.size.height>dlRect.size.height){
        dlRectNew.size.height = dlRect.size.height;
        [self setFrame:dlRectNew];
    }
}

@end
