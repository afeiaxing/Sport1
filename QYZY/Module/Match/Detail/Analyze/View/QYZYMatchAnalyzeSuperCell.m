//
//  QYZYMatchAnalyzeSuperCell.m
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import "QYZYMatchAnalyzeSuperCell.h"
#import "QYZYIntegralHeaderView.h"
#import "QYZYIntegralCell.h"

#import "QYZYHistoryHeaderView.h"
#import "QYZYHistoryCell.h"

#import "QYZYMatchAnalyzeFooterView.h"

#import "QYZYMatchHeaderView.h"
#import "QYZYHostGuessMatchCell.h"

@interface QYZYMatchAnalyzeSuperCell ()
@property (nonatomic ,strong) QYZYIntegralHeaderView *integralHeaderView;
@end

@implementation QYZYMatchAnalyzeSuperCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setSubType:(QYZYAnalyzeSubType)subType {
    _subType = subType;
    [self.tableView reloadData];
}

- (void)setHistoryMatchModel:(QYZYSubMatchModel *)historyMatchModel {
    if (historyMatchModel == nil) return;
    _historyMatchModel = historyMatchModel;
    [self.tableView reloadData];
}

- (void)setHostMatchModel:(QYZYSubMatchModel *)hostMatchModel {
    if (hostMatchModel == nil) return;
    _hostMatchModel = hostMatchModel;
    [self.tableView reloadData];
}

- (void)setGuessMatchModel:(QYZYSubMatchModel *)guessMatchModel {
    if (guessMatchModel == nil) return;
    _guessMatchModel = guessMatchModel;
    [self.tableView reloadData];
}

- (void)setRankArray:(NSArray<QYZYMatchAnalyzeRankSubModel *> *)rankArray {
    _rankArray = rankArray;
    [self.tableView reloadData];
}

- (void)setIsBasket:(BOOL)isBasket {
    _isBasket = isBasket;
    [self.tableView reloadData];
}

- (void)setHostFutureArray:(NSArray<QYZYMatchMainModel *> *)hostFutureArray {
    _hostFutureArray = hostFutureArray;
    [self.tableView reloadData];
}

- (void)setGuestFutureArray:(NSArray<QYZYMatchMainModel *> *)guestFutureArray {
    _guestFutureArray = guestFutureArray;
    [self.tableView reloadData];
}

#pragma mark - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据~" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} ];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_noData"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.subType == QYZYAnalyzeSubTypeIntegral) {
        return self.rankArray.count;
    }
    if (self.subType == QYZYAnalyzeSubTypeHistory) {
        return self.historyMatchModel.matches.count;
    }
    if (self.subType == QYZYAnalyzeSubTypeHost) {
        return self.hostMatchModel.matches.count;
    }
    if (self.subType == QYZYAnalyzeSubTypeGuest) {
        return self.guessMatchModel.matches.count;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.subType == QYZYAnalyzeSubTypeHistory) {
        QYZYHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYHistoryCell.class)];
        if (indexPath.row < self.historyMatchModel.matches.count) {
            QYZYMatchDetailModel *model = self.historyMatchModel.matches[indexPath.row];
            model.sportId = self.historyMatchModel.sportId;
            cell.model = model;
        }
        if (indexPath.row % 2 == 0) {
            cell.contentView.backgroundColor = rgb(255, 255, 255);
        }else {
            cell.contentView.backgroundColor = rgb(246, 247, 249);
        }
        return cell;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeHost) {
        QYZYHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYHistoryCell.class)];
        if (indexPath.row < self.hostMatchModel.matches.count) {
            QYZYMatchDetailModel *model = self.hostMatchModel.matches[indexPath.row];
            model.sportId = self.hostMatchModel.sportId;
            cell.model = model;
        }
        if (indexPath.row % 2 == 0) {
            cell.contentView.backgroundColor = rgb(255, 255, 255);
        }else {
            cell.contentView.backgroundColor = rgb(246, 247, 249);
        }
        return cell;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeGuest) {
        QYZYHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYHistoryCell.class)];
        if (indexPath.row < self.guessMatchModel.matches.count) {
            QYZYMatchDetailModel *model = self.guessMatchModel.matches[indexPath.row];
            model.sportId = self.guessMatchModel.sportId;
            cell.model = model;
        }
        if (indexPath.row % 2 == 0) {
            cell.contentView.backgroundColor = rgb(255, 255, 255);
        }else {
            cell.contentView.backgroundColor = rgb(246, 247, 249);
        }
        return cell;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeHostMatch) {
        QYZYHostGuessMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYHostGuessMatchCell.class)];
        if (indexPath.row < self.hostFutureArray.count) {
            cell.mainModel = self.hostFutureArray[indexPath.row];
        }
        return cell;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeGuestMatch) {
        QYZYHostGuessMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYHostGuessMatchCell.class)];
        if (indexPath.row < self.guestFutureArray.count) {
            cell.mainModel = self.guestFutureArray[indexPath.row];
        }
        return cell;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeIntegral) {
        QYZYIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYIntegralCell.class)];
        cell.isBasket = self.isBasket;
        if (indexPath.row < self.rankArray.count) {
            cell.subModel = self.rankArray[indexPath.row];
        }
        return cell;
    }

    return [UITableViewCell new];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.subType == QYZYAnalyzeSubTypeHistory || self.subType == QYZYAnalyzeSubTypeHost || self.subType == QYZYAnalyzeSubTypeGuest) {
        return 40;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.subType == QYZYAnalyzeSubTypeHistory) {
        QYZYHistoryHeaderView *view = [[QYZYHistoryHeaderView alloc] init];
        view.sportId = self.historyMatchModel.sportId;
        return view;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeHost) {
        QYZYHistoryHeaderView *view = [[QYZYHistoryHeaderView alloc] init];
        view.sportId = self.hostMatchModel.sportId;
        return view;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeGuest) {
        QYZYHistoryHeaderView *view = [[QYZYHistoryHeaderView alloc] init];
        view.sportId = self.guessMatchModel.sportId;
        return view;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeHostMatch || self.subType == QYZYAnalyzeSubTypeGuestMatch) {
        return [[QYZYMatchHeaderView alloc] init];
    }
    if (self.subType == QYZYAnalyzeSubTypeIntegral) {
        if (self.integralHeaderView == nil) {
            self.integralHeaderView = [[QYZYIntegralHeaderView alloc] init];
        }
        self.integralHeaderView.isBasket = self.isBasket;
        return self.integralHeaderView;
    }
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.subType == QYZYAnalyzeSubTypeHistory) {
        QYZYMatchAnalyzeFooterView *view = [[QYZYMatchAnalyzeFooterView alloc] init];
        view.historyMatchModel = self.historyMatchModel;
        return view;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeHost) {
        QYZYMatchAnalyzeFooterView *view = [[QYZYMatchAnalyzeFooterView alloc] init];
        view.hostMatchModel = self.hostMatchModel;
        return view;
    }
    
    if (self.subType == QYZYAnalyzeSubTypeGuest) {
        QYZYMatchAnalyzeFooterView *view = [[QYZYMatchAnalyzeFooterView alloc] init];
        view.guessMatchModel = self.guessMatchModel;
        return view;
    }
    
    return [UIView new];
}

#pragma mark - Get
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];
        _tableView.sectionHeaderHeight = 40;
        _tableView.scrollEnabled = NO;
        _tableView.mj_footer.hidden = YES;
        [_tableView registerClass:[QYZYIntegralCell class] forCellReuseIdentifier:NSStringFromClass(QYZYIntegralCell.class)];
        [_tableView registerClass:[QYZYHistoryCell class] forCellReuseIdentifier:NSStringFromClass(QYZYHistoryCell.class)];
        [_tableView registerClass:[QYZYHostGuessMatchCell class] forCellReuseIdentifier:NSStringFromClass(QYZYHostGuessMatchCell.class)];
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}

@end
