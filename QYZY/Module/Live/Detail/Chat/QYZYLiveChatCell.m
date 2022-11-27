//
//  QYZYLiveChatCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYLiveChatCell.h"
@interface QYZYLiveChatCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation QYZYLiveChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = rgb(248, 249, 254);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChatModel:(QYZYLiveChatModel *)chatModel {
    _chatModel = chatModel;
    NSString *content = [NSString stringWithFormat:@"%@:%@",chatModel.nickname,chatModel.content];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:content attributes:@{
        NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Regular" size:14],
        NSForegroundColorAttributeName : rgb(34, 34, 34)
    }];
    [attri addAttribute:NSForegroundColorAttributeName value:rgb(23, 127, 255) range:NSMakeRange(0, chatModel.nickname.length)];
    self.contentLabel.attributedText = attri;
}

@end
