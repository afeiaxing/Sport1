//
//  QYZYResultLiveRoomCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "QYZYResultLiveRoomCell.h"

@implementation QYZYResultLiveRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.leftImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightImgView.contentMode = UIViewContentModeScaleAspectFill;
    self.leftTitleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    self.rightTitleLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
    self.rightNameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:10];
    
    self.leftContainer.userInteractionEnabled = YES;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTap:)];
    [self.leftContainer addGestureRecognizer:leftTap];
    
    self.rightContainer.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap:)];
    [self.rightContainer addGestureRecognizer:rightTap];

}

- (void)leftTap:(UITapGestureRecognizer *)tap {
    QYZYSearchLiveModel *leftModel = self.models.firstObject;
    !self.block?:self.block(leftModel.anchorId);
}

- (void)rightTap:(UITapGestureRecognizer *)tap {
    if (self.models.count == 2) {
        QYZYSearchLiveModel *rightModel = self.models.lastObject;
        !self.block?:self.block(rightModel.anchorId);
    }
}

- (void)setModels:(NSMutableArray *)models {
    _models = models;
    QYZYSearchLiveModel *leftModel = models.firstObject;
    [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:leftModel.roomImg] placeholderImage:QYZY_DEFAULT_LOGO];
    self.leftTitleLab.text = leftModel.title;
    self.nameLabel.text = leftModel.nickname;
    
    if (models.count == 2) {
        QYZYSearchLiveModel *rightModel = models.lastObject;
        [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:rightModel.roomImg] placeholderImage:QYZY_DEFAULT_LOGO];
        self.rightTitleLab.text = rightModel.title;
        self.rightNameLabel.text = rightModel.nickname;
        self.rightContainer.backgroundColor = UIColor.whiteColor;
    }
    
    if (models.count == 1) {
        self.rightContainer.backgroundColor = UIColor.clearColor;
    }
}

@end
