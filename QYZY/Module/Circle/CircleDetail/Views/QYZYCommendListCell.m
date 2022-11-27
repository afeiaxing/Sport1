//
//  QYZYCommendListCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCommendListCell.h"
#import "NSString+Category.h"

@implementation QYZYCommendListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:12];
    self.contentLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.replyLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.replyLab.text = @"回复>";
    self.atLab.backgroundColor = rgba(238, 238, 238, 0.5);
    self.atLab.layer.cornerRadius = 4;
    self.atLab.layer.masksToBounds = YES;
    self.atLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
}

- (void)setModel:(QYZYCircleCommendModel *)model {
    _model = model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.titleLab.text = model.nickname;
    self.contentLab.text = model.content;
    self.timeLab.text = model.createdDate;
    self.likeLab.text = model.likeCount;
    
    if (self.needAtReply) {
        if (model.replyId.integerValue == model.replyMainId.integerValue ||
            !QYZYUserManager.shareInstance.isLogin) {
            self.atContentHeight.constant = 1;
            self.atLab.hidden = YES;
        }else {
            NSString *string = [NSString stringWithFormat:@"@%@:%@",model.parent.nickname,model.parent.content];
            CGFloat width = ScreenWidth - 56 - 12;
            CGFloat height = [string getHeightWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] widthLimit:width] + 8;
            self.atContentHeight.constant = height;
            self.atLab.text = string;
            self.atLab.hidden = NO;
        }
    }else {
        self.atLab.hidden = YES;
    }
}

- (void)setNewsCommentModel:(QYZYNewsCommentModel *)newsCommentModel {
    _newsCommentModel = newsCommentModel;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:newsCommentModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.titleLab.text = newsCommentModel.nickName;
    self.timeLab.text = newsCommentModel.createdDate;
    self.contentLab.text = newsCommentModel.content;
    self.likeLab.text = newsCommentModel.likeCount;
}

- (void)setParentModel:(QYZYNewsCommentSubParentModel *)parentModel {
    _parentModel = parentModel;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:parentModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.titleLab.text = parentModel.nickName;
    self.timeLab.text = parentModel.createdDate;
    self.contentLab.text = parentModel.content;
    self.likeLab.text = parentModel.likeCount;
}

- (void)setSonCommentsModel:(QYZYNewsCommentSubSonCommentsModel *)sonCommentsModel {
    _sonCommentsModel = sonCommentsModel;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:sonCommentsModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    self.titleLab.text = sonCommentsModel.nickName;
    self.timeLab.text = sonCommentsModel.createdDate;
    self.contentLab.text = sonCommentsModel.content;
    self.likeLab.text = sonCommentsModel.likeCount;
}

@end
