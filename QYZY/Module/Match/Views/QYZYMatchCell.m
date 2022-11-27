//
//  QYZYMatchCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import "QYZYMatchCell.h"

@interface QYZYMatchCell ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *leagueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *halfLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation QYZYMatchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup {
    self.contentView.backgroundColor = rgb(248, 249, 254);
    self.containerView.backgroundColor = UIColor.whiteColor;
    self.containerView.layer.cornerRadius = 50;
    self.containerView.layer.shadowColor = rgb(106, 119, 157).CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowOpacity = 0.19;
    self.leagueLabel.textColor = rgb(225, 89, 255);
    self.leagueLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    self.stateLabel.textColor = rgb(246, 83, 72);
    self.stateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    self.hostLabel.textColor = rgb(51, 51, 51);
    self.hostLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    self.guestLabel.textColor = rgb(51, 51, 51);
    self.guestLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:13];
    self.lineLabel.textColor = rgb(41, 69, 192);
    self.hostScoreLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:14];
    self.hostScoreLabel.textColor = rgb(41, 69, 192);
    self.guestScoreLabel.font = [UIFont fontWithName:@"DINAlternate-Bold" size:14];
    self.guestScoreLabel.textColor = rgb(41, 69, 192);
    self.halfLabel.layer.cornerRadius = 12;
    self.halfLabel.layer.masksToBounds = YES;
    self.halfLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    self.halfLabel.textColor = rgb(97, 112, 152);
    self.timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    self.timeLabel.textColor = rgb(246, 83, 72);
}

- (void)setDetailModel:(QYZYMatchDetailModel *)detailModel {
    _detailModel = detailModel;
    self.leagueLabel.text = detailModel.leagueName;
    self.hostLabel.text = detailModel.hostTeamName;
    self.guestLabel.text = detailModel.guestTeamName;
    self.stateLabel.text = detailModel.statusLable;
    self.hostScoreLabel.text = detailModel.hostTeamScore;
    self.guestScoreLabel.text = detailModel.guestTeamScore;
    self.halfLabel.text = [NSString stringWithFormat:@"半%@-%@",detailModel.hostHalfScore,detailModel.guestHalfScore];
    self.timeLabel.text = [self time_timestampToString:detailModel.matchTime.integerValue];
}

- (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}

@end
