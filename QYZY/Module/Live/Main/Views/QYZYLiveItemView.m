//
//  QYZYLiveItemView.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveItemView.h"

@implementation QYZYLiveItemView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupSubViews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
}

- (void)setupSubViews {
    self.bottomView.backgroundColor = rgba(27, 26, 30, 0.2);
    self.titleLabel.textColor = rgb(34, 34, 34);
}

- (void)setListModel:(QYZYLiveListModel *)listModel {
    _listModel = listModel;
    self.nameLabel.text = listModel.nickname;
    self.titleLabel.text = listModel.liveTitle;
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:listModel.liveImage] placeholderImage:QYZY_DEFAULT_LOGO];
    self.hotLabel.text = listModel.anchorHot;
}

@end
