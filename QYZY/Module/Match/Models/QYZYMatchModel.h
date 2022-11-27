//
//  QYZYMatchModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchDetailModel : NSObject
@property (nonatomic, strong) NSString *sportId;
@property (nonatomic ,strong) NSString *matchTime;
@property (nonatomic ,strong) NSString *matchId;
@property (nonatomic ,strong) NSString *hostTeamName;
@property (nonatomic ,strong) NSString *guestTeamName;
@property (nonatomic ,strong) NSString *leagueName;
@property (nonatomic ,strong) NSString *statusLable;
@property (nonatomic ,strong) NSString *hostTeamScore;
@property (nonatomic ,strong) NSString *guestTeamScore;
@property (nonatomic ,strong) NSString *hostCorner;
@property (nonatomic ,strong) NSString *guestCorner;
@property (nonatomic ,strong) NSString *hostHalfScore;
@property (nonatomic ,strong) NSString *guestHalfScore;

@property (nonatomic, strong) NSString *dxRate;

@end

@interface QYZYSubMatchModel : NSObject
@property (nonatomic ,strong) NSString *count;
@property (nonatomic ,strong) NSArray <QYZYMatchDetailModel *> *matches;
@property (nonatomic, copy) NSString *hostWinNum;
@property (nonatomic, copy) NSString *hostLoseNum;
@property (nonatomic, copy) NSString *hostDrawNum;
@property (nonatomic, copy) NSString *hostScore;
@property (nonatomic, copy) NSString *guestScore;
@property (nonatomic, strong) NSString *sportId;


@property (nonatomic, copy) NSString *pointsLostPerGame;
@property (nonatomic, copy) NSString *pointsGetPerGame;


@end

@interface QYZYMatchModel : NSObject
@property (nonatomic ,strong) QYZYSubMatchModel *finished;
@property (nonatomic ,strong) QYZYSubMatchModel *going;
@property (nonatomic ,strong) QYZYSubMatchModel *uncoming;
@property (nonatomic ,strong) QYZYSubMatchModel *unknown;
@end

NS_ASSUME_NONNULL_END
