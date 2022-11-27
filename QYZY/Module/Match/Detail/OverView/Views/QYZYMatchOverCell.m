//
//  QYZYMatchOverCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYMatchOverCell.h"

@interface QYZYMatchOverCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end

@implementation QYZYMatchOverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = rgb(248, 249, 254);
    [self setupSubView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupSubView {
    self.containerView.layer.cornerRadius = 8;
    self.containerView.backgroundColor = UIColor.whiteColor;
    self.timeLabel.textColor = rgb(34, 34, 34);
    self.timeLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:20];
    self.contentLabel.textColor = rgb(34, 34, 34);
    self.contentLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView);
        make.left.equalTo(self.timeLabel.mas_right).offset(12);
        make.right.equalTo(self.containerView).offset(-12);
    }];
}

- (void)setOverModel:(QYZYMatchOverModel *)overModel {
    _overModel = overModel;
    self.timeLabel.text = [NSString stringWithFormat:@"%@'",overModel.time];
    self.contentLabel.text = overModel.cnText;
}

@end
