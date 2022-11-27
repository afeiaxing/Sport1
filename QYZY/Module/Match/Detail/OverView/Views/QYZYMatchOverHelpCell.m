//
//  QYZYMatchOverHelpCell.m
//  QYZY
//
//  Created by jsgordong on 2022/10/25.
//

#import "QYZYMatchOverHelpCell.h"

@implementation QYZYMatchOverHelpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDict:(NSDictionary *)dict {
    self.iconIv.image = [UIImage imageNamed:dict[@"icon"]];
    self.titleLab.text = dict[@"title"];
}

@end
