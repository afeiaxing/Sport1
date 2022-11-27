//
//  QYZYLiveRankCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYLiveRankCell.h"
#import "QYZYLiveFocusControl.h"
#import "QYZYPersonalhomepageViewController.h"

@interface QYZYLiveRankCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *contributionLabel;
@property (nonatomic ,strong) QYZYLiveFocusControl *focus;

@end

@implementation QYZYLiveRankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = rgb(248, 249, 254);
    self.containerView.layer.shadowColor = rgb(105, 118, 157).CGColor;
    self.containerView.layer.shadowOpacity = 0.19;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.cornerRadius = 8;
    self.rankLabel.textColor = rgb(34, 34, 34);
    self.rankLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:20];
    self.nameLabel.textColor = rgb(34, 34, 34);
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    self.fansLabel.textColor = rgb(149, 157, 176);
    self.fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.headImageView.layer.cornerRadius = 18;
    self.headImageView.layer.masksToBounds = YES;
    self.iconImageView.hidden = YES;
    self.contributionLabel.hidden = YES;
    self.contributionLabel.textColor = rgb(255, 176, 25);
    self.contributionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.typeImageView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterUserHomePage)];
    [self.headImageView addGestureRecognizer:tap];
    self.headImageView.userInteractionEnabled = YES;
    
    [self.containerView addSubview:self.focus];
    [self.focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(64, 24));
        make.right.equalTo(self.containerView).offset(-14);
        make.centerY.equalTo(self.containerView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)focusAction {
    if (!QYZYUserManager.shareInstance.isLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [UIViewController.currentViewController presentViewController:vc animated:true completion:nil];
        });
        return;
    }
    !self.focusBlock ? : self.focusBlock(self.rankModel);
}

- (void)setRankModel:(QYZYLiveRankModel *)rankModel {
    _rankModel = rankModel;
    self.rankLabel.text = rankModel.rankOrder;
    self.nameLabel.text = rankModel.nickname;
    self.fansLabel.text = [NSString stringWithFormat:@"粉丝数 %@",rankModel.fansCount];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:rankModel.headImgUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
    self.iconImageView.hidden = rankModel.anchorContribution.integerValue;
    self.contributionLabel.hidden = rankModel.anchorContribution.integerValue;
    self.contributionLabel.text = rankModel.anchorContribution.stringValue;
    self.typeImageView.hidden = rankModel.rankType.integerValue;
    NSString *typeImageName = @"live_detail_rank_up";
    if (rankModel.rankType.integerValue == 2) {
        typeImageName = @"live_detail_rank_down";
    }
    self.typeImageView.image = [UIImage imageNamed:typeImageName];
    self.focus.selected = rankModel.focusStatus;
    if (QYZYUserManager.shareInstance.isLogin) {
        self.focus.hidden = [QYZYUserManager.shareInstance.userModel.uid.stringValue isEqualToString:rankModel.userId];
    }
    else {
        self.focus.hidden = NO;
    }
}

- (void)enterUserHomePage {
    QYZYPersonalhomepageViewController *personalVc = [[QYZYPersonalhomepageViewController alloc] init];
    personalVc.authorId = self.rankModel.userId;
    personalVc.hidesBottomBarWhenPushed = YES;
    [UIViewController.currentViewController.navigationController pushViewController:personalVc animated:YES];
}

- (QYZYLiveFocusControl *)focus {
    if (!_focus) {
        _focus = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(QYZYLiveFocusControl.class) owner:self options:nil].firstObject;
        _focus.layer.cornerRadius = 12;
        _focus.layer.masksToBounds = YES;
        [_focus addTarget:self action:@selector(focusAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _focus;
}

@end
