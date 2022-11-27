//
//  QYZYMatchMainModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchMainModel : NSObject
@property (nonatomic ,strong) NSString *trendAnim;
@property (nonatomic ,strong) NSString *animUrl;
@property (nonatomic ,strong) NSString *obliqueAnimUrl;
@property (nonatomic ,strong) NSString *matchId;
@property (nonatomic ,strong) NSString *hostTeamId;
@property (nonatomic ,strong) NSString *hostTeamLogo;
@property (nonatomic ,strong) NSString *hostTeamName;
@property (nonatomic ,strong) NSString *guestTeamId;
@property (nonatomic ,strong) NSString *guestTeamLogo;
@property (nonatomic ,strong) NSString *guestTeamName;
@property (nonatomic ,strong) NSString *sportId;
@property (nonatomic ,strong) NSString *leagueId;
@property (nonatomic ,strong) NSString *leagueNick;
@property (nonatomic ,strong) NSString *leagueName;
@property (nonatomic ,strong) NSString *round;
@property (nonatomic ,strong) NSString *matchTime;
@property (nonatomic ,strong) NSString *groupName;
@property (nonatomic, strong) NSString *hostTeamScore;
@property (nonatomic, strong) NSString *guestTeamScore;
@property (nonatomic, strong) NSString *hostTeamHalfScore;
@property (nonatomic, strong) NSString *guestTeamHalfScore;
@property (nonatomic, strong) NSString *timeInterval;
@property (nonatomic, strong) NSNumber *matchStatusCode;
@property (nonatomic ,strong) NSNumber *timePlayed;
@property (nonatomic ,strong) NSNumber *matchStatus;
@end

NS_ASSUME_NONNULL_END
