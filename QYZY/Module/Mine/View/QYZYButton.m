//
//  QYZYButton.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYButton.h"

@implementation QYZYButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(36, 0);
    CGFloat heightDelta = MAX(36, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}


@end
