//
//  QYZYLiveAnchorHeaderView.m
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "QYZYLiveAnchorHeaderView.h"
#import "QYZYPersonalhomepageViewController.h"

@interface QYZYLiveAnchorHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIView *announceView;
@property (weak, nonatomic) IBOutlet UILabel *announceLabel;

@end

@implementation QYZYLiveAnchorHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = rgb(248, 249, 254);
    self.containerView.layer.cornerRadius = 8;
    self.containerView.layer.shadowColor = rgb(105, 118, 157).CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowRadius = 8;
    self.containerView.layer.shadowOpacity = 0.19;
    self.headerImageView.layer.cornerRadius = 18;
    self.headerImageView.layer.masksToBounds = YES;
    self.nameLabel.textColor = rgb(34, 34, 34);
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    self.fansLabel.textColor = rgb(149, 157, 176);
    self.fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.announceView.backgroundColor = rgb(245, 250, 255);
    self.announceView.layer.cornerRadius = 15;
    self.announceLabel.textColor = rgb(89, 113, 255);
    self.announceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterUserHomePage)];
    [self.headerImageView addGestureRecognizer:tap];
    self.headerImageView.userInteractionEnabled = YES;
}

- (void)setDetailModel:(QYZYLiveDetailModel *)detailModel {
    _detailModel = detailModel;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.headImageUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
    self.nameLabel.text = detailModel.nickname;
    self.fansLabel.text = [NSString stringWithFormat:@"粉丝数 %@",detailModel.fans];
    self.announceLabel.text = detailModel.profile;
}

- (void)enterUserHomePage {
    QYZYPersonalhomepageViewController *personalVc = [[QYZYPersonalhomepageViewController alloc] init];
    personalVc.authorId = self.detailModel.userId;
    personalVc.hidesBottomBarWhenPushed = YES;
    [UIViewController.currentViewController.navigationController pushViewController:personalVc animated:YES];
}

@end
