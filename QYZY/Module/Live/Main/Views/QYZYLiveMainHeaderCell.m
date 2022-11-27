//
//  QYZYLiveMainHeaderCell.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveMainHeaderCell.h"

@interface QYZYLiveMainHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation QYZYLiveMainHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = UIColor.whiteColor;
}

- (void)layoutSubviews {

    [super layoutSubviews];

    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(48);
        make.top.equalTo(self.contentView).offset(8);
        make.centerX.equalTo(self.contentView);
    }];
    self.headImageView.layer.cornerRadius = 24;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.backgroundColor = rgb(246, 247, 249);
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.headImageView.mas_bottom).offset(2);
        make.width.mas_equalTo(64);
    }];
    self.nameLabel.textColor = rgb(44, 45, 46);
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    [self layoutIfNeeded];
}


- (void)setHotModel:(QYZYLiveMainHotModel *)hotModel {
    _hotModel = hotModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.headImageUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
    self.nameLabel.text = hotModel.nickName;
}

@end
