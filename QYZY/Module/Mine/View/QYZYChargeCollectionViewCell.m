//
//  QYZYChargeCollectionViewCell.m
//  QYZY
//
//  Created by jsmaster on 10/14/22.
//

#import "QYZYChargeCollectionViewCell.h"
#import "QYZYChargeModel.h"

@interface QYZYChargeCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@end

@implementation QYZYChargeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectImageView.hidden = YES;
    self.layer.borderWidth = 1;
    self.priceLabel.font = [UIFont fontWithName:@"MicrosoftYaHeiUI" size:14];
}

- (void)setModel:(QYZYChargeModel *)model {
    _model = model;
    NSString *unit = @"财富豆";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:model.desc];
    if ([att.string containsString:unit]) {
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINAlternate-Bold" size:18] range:NSMakeRange(0, att.string.length - unit.length)];
        [att addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:12] range:NSMakeRange(att.string.length - unit.length, unit.length)];
    }
    self.titleLabel.attributedText = att;
    self.priceLabel.text = [NSString stringWithFormat:@"%@元", model.price];
    self.selectImageView.hidden = !model.selected;
    if (model.selected) {
        self.priceLabel.textColor = rgb(41, 69, 192);
        self.titleLabel.textColor = rgb(41, 69, 192);
        self.layer.borderColor = rgb(41, 69, 192).CGColor;
    } else {
        self.priceLabel.textColor = rgb(153, 153, 153);
        self.titleLabel.textColor = rgb(34, 34, 34);
        self.layer.borderColor = rgb(238, 238, 238).CGColor;
    }
}


@end
