//
//  QYZYMatchHomeCell.m
//  QYZY
//
//  Created by jspollo on 2022/10/20.
//

#import "QYZYMatchHomeCell.h"

@interface QYZYMatchHomeCell ()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *leagueLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hostImageView;
@property (weak, nonatomic) IBOutlet UIImageView *guestImageView;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *guestScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *rightLineView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@end

@implementation QYZYMatchHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup {
    self.lineView.backgroundColor = rgba(229, 229, 234, 0.6);
    [self.contentView bringSubviewToFront:self.lineView];
    self.leagueLabel.textColor = rgb(149, 157, 176);
    self.leagueLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.timeLabel.textColor = rgb(149, 157, 176);
    self.timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    self.hostLabel.textColor = rgb(34, 34, 34);
    self.hostLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.guestLabel.textColor = rgb(34, 34, 34);
    self.guestLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.hostScoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.hostScoreLabel.textColor = rgb(246, 83, 72);
    self.guestScoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    self.guestScoreLabel.textColor = rgb(246, 83, 72);
    self.stateLabel.textColor = rgb(242, 97, 97);
    self.stateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.rightLineView.backgroundColor = rgb(229, 229, 234);
}

- (void)setDetailModel:(QYZYMatchDetailModel *)detailModel {
    _detailModel = detailModel;
    self.leagueLabel.text = detailModel.leagueName;
    self.timeLabel.text = [self time_timestampToString:detailModel.matchTime.integerValue];
    self.hostLabel.text = detailModel.hostTeamName;
    self.guestLabel.text = detailModel.guestTeamName;
    self.hostScoreLabel.text = detailModel.hostTeamScore;
    self.guestScoreLabel.text = detailModel.guestTeamScore;
    self.stateLabel.text = detailModel.statusLable;
}

- (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}

@end
