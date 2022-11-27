//
//  QYZYChatGiftCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "QYZYChatGiftCell.h"

@interface QYZYChatGiftCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation QYZYChatGiftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = rgb(17, 17, 17);
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.priceLabel.textColor = rgb(64, 140, 255);
    self.priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
    self.layer.borderColor = rgb(41, 69, 192).CGColor;
}

- (void)setGiftModel:(QYZYChatGiftModel *)giftModel {
    _giftModel = giftModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:giftModel.imgUrl] placeholderImage:QYZY_DEFAULT_LOGO];
    self.nameLabel.text = giftModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"%@财富豆",[self dealWithPriceWithPrice:giftModel.price]];
    self.layer.borderWidth = giftModel.isClick ? 1.6 : 0;
}

- (NSString *)dealWithPriceWithPrice:(NSInteger)price {
    if (price % 100 != 0) {
        return [NSString stringWithFormat:@"%0.2f",price/100.0];
    } else {
        return [NSString stringWithFormat:@"%ld",price/100];
    }
}

@end
