//
//  QYZYChargeCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/4.
//

#import "QYZYChargeCell.h"

@interface QYZYChargeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end

@implementation QYZYChargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = rgb(64, 140, 255);
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.priceLabel.textColor = rgb(102, 191, 102);
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    [self setsubView];
}

- (void)setsubView {
    self.titleLabel.text = @"98财富豆";
    self.priceLabel.text = @"98";
}

@end
