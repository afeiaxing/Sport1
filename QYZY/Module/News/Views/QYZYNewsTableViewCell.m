//
//  QYZYNewsTableViewCell.m
//  QYZY
//
//  Created by jsmaster on 10/1/22.
//

#import "QYZYNewsTableViewCell.h"
#import "QYZYTopBlocksModel.h"

@interface QYZYNewsTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *readCountLabel;
@end

@implementation QYZYNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(QYZYTopBlocksModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.timeLabel.text = model.createdDate;
    self.readCountLabel.text = model.commentCount;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:QYZY_DEFAULT_LOGO];
}

@end
