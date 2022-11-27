//
//  QYZYMineCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/21.
//

#import "QYZYMineCell.h"
@interface QYZYMineCell ()
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
@implementation QYZYMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup {
    self.lineView.backgroundColor = rgb(242, 242, 242);
    UIImage *image = [[UIImage imageNamed:@"icon_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.arrowView.tintColor = rgb(193, 198, 211);
    self.arrowView.image = image;
    self.titleLabel.textColor = rgb(34, 34, 34);
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
}

@end
