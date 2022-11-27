//
//  QYZYResultAnchorCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "QYZYResultAnchorCell.h"

@implementation QYZYResultAnchorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    self.subTitleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:12];
}

- (void)setModel:(QYZYSearchAnchorModel *)model {
    _model = model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
    self.nameLabel.text = model.nickname;
    self.subTitleLabel.text =  model.fans;
    
    if (model.isLive.integerValue == 1) {
        [self.statusBtn setTitle:@"直播中" forState:UIControlStateNormal];
        self.statusBtn.layer.borderWidth = 0;
        self.statusBtn.backgroundColor = rgb(246, 83, 72);
        [self.statusBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }else {
        if (model.isAttention.integerValue == 0) {
            [self.statusBtn setTitle:@"关注" forState:UIControlStateNormal];
            [self.statusBtn setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
            self.statusBtn.layer.borderWidth = 1;
            self.statusBtn.backgroundColor = UIColor.whiteColor;
            self.statusBtn.layer.borderColor = rgb(149, 157, 176).CGColor;
        }else {
            [self.statusBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [self.statusBtn setTitleColor:rgb(149, 157, 176) forState:UIControlStateNormal];
            self.statusBtn.layer.borderWidth = 1;
            self.statusBtn.backgroundColor = UIColor.whiteColor;
            self.statusBtn.layer.borderColor = rgb(149, 157, 176).CGColor;
        }
    }
}

@end
