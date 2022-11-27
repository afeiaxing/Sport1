//
//  QYZYMatchAnalyzeSuperCell.h
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import <UIKit/UIKit.h>
#import "QYZYMatchViewModel.h"
#import "QYZYMatchMainModel.h"

typedef NS_ENUM(NSInteger ,QYZYAnalyzeSubType) {
    QYZYAnalyzeSubTypeIntegral,
    QYZYAnalyzeSubTypeHistory,
    QYZYAnalyzeSubTypeHost,
    QYZYAnalyzeSubTypeGuest,
    QYZYAnalyzeSubTypeHostMatch,
    QYZYAnalyzeSubTypeGuestMatch
};

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchAnalyzeSuperCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) QYZYSubMatchModel *historyMatchModel;
@property (nonatomic, strong) QYZYSubMatchModel *hostMatchModel;
@property (nonatomic, strong) QYZYSubMatchModel *guessMatchModel;
@property (nonatomic, strong) NSArray <QYZYMatchAnalyzeRankSubModel *> *rankArray;
@property (nonatomic, strong) NSArray <QYZYMatchMainModel *> *hostFutureArray;
@property (nonatomic, strong) NSArray <QYZYMatchMainModel *> *guestFutureArray;
@property (nonatomic ,assign) BOOL isBasket; /// 是否篮球，默认否
@property (nonatomic ,assign) QYZYAnalyzeSubType subType;

@property (nonatomic, strong) UITableView *tableView;


@end

NS_ASSUME_NONNULL_END
