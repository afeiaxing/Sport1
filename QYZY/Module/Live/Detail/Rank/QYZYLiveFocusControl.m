//
//  QYZYLiveFocusControl.m
//  QYZY
//
//  Created by jspollo on 2022/10/3.
//

#import "QYZYLiveFocusControl.h"

@interface QYZYLiveFocusControl ()
@property (weak, nonatomic) IBOutlet UILabel *focusLabel;
@end

@implementation QYZYLiveFocusControl

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = rgb(149, 157, 176).CGColor;
    self.layer.borderWidth = 0;
    self.focusLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.layer.borderWidth = 1;
        self.focusLabel.textColor = rgb(149, 157, 176);
        self.focusLabel.text = @"已关注";
        self.backgroundColor = UIColor.whiteColor;
    }
    else {
        self.layer.borderWidth = 0;
        self.focusLabel.textColor = UIColor.whiteColor;
        self.focusLabel.text = @"关注";
        self.backgroundColor = rgb(41, 69, 192);
    }
}

@end
