//
//  QYZYMatchAnalyzeViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/14.
//

#import "QYZYMatchAnalyzeViewController.h"
#import "QYZYAnalyzeSubViewController.h"
#import "QYZYMatchAnalyzeSuperCell.h"
#import "QYZYAnalyzeHeaderFooterView.h"

#import "QYZYMatchViewModel.h"
#import "QYZYAnalyzeSectionModel.h"

#import "QYZYAnalyzeSectionTool.h"

@interface QYZYMatchAnalyzeViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) QYZYMatchViewModel *viewModel;

@property (nonatomic, strong) QYZYSubMatchModel *historyMatchModel;
@property (nonatomic, strong) QYZYSubMatchModel *hostMatchModel;
@property (nonatomic, strong) QYZYSubMatchModel *guessMatchModel;
@property (nonatomic, strong) QYZYMatchAnalyzeRankModel *rankModel;
@property (nonatomic, strong) NSArray <QYZYMatchMainModel *> *hostFutureArray;
@property (nonatomic, strong) NSArray <QYZYMatchMainModel *> *guestFutureArray;

@property (nonatomic, assign) BOOL isHistorySameHostGuest;
@property (nonatomic, assign) BOOL isHistorySameLeague;

@end

@implementation QYZYMatchAnalyzeViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)setDetailModel:(QYZYMatchMainModel *)detailModel {
    _detailModel = detailModel;
    
    self.groups =  @[@"积分排名",@"历史交手",@"主队近况",@"客队近况",@"主队赛程",@"客队赛程"];
    self.sections = [QYZYAnalyzeSectionTool handleData];
    self.isHistorySameLeague = NO;
    self.isHistorySameHostGuest = YES;
    
    self.viewModel.isBasket = ![detailModel.sportId isEqualToString:@"1"];
    [self requestData];
}

- (void)requestData {
    QYZYAnalyzeSectionModel *historyModel = self.sections[1];
    weakSelf(self);
    [self.viewModel requestAnalyzeHistoryWithMatchId:self.detailModel.matchId
                                          hostTeamId:self.detailModel.hostTeamId
                                         guestTeamId:self.detailModel.guestTeamId
                                            leagueId:self.detailModel.leagueId
                                     isSameHostGuest:historyModel.isHomeAwayBtnSelect
                                        isSameLeague:historyModel.isMatchBtnSelect
                                          completion:^(QYZYSubMatchModel *model) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        self.historyMatchModel = model;
        self.historyMatchModel.sportId = self.detailModel.sportId;
        [self.tableView reloadData];
    }];
    QYZYAnalyzeSectionModel *hostModel = self.sections[2];
    [self.viewModel requestAnalyzeRecentWithMatchId:self.detailModel.matchId
                                             teamId:self.detailModel.hostTeamId
                                               side:@"all"
                                           leagueId:self.detailModel.leagueId
                                    isSameHostGuest:hostModel.isHomeAwayBtnSelect
                                       isSameLeague:hostModel.isMatchBtnSelect
                                         completion:^(QYZYSubMatchModel * _Nonnull model) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        self.hostMatchModel = model;
        self.hostMatchModel.sportId = self.detailModel.sportId;
        [self.tableView reloadData];
    }];
    QYZYAnalyzeSectionModel *guestModel = self.sections[3];
    [self.viewModel requestAnalyzeRecentWithMatchId:self.detailModel.matchId
                                             teamId:self.detailModel.guestTeamId
                                               side:@"all"
                                           leagueId:self.detailModel.leagueId
                                    isSameHostGuest:guestModel.isHomeAwayBtnSelect
                                       isSameLeague:guestModel.isMatchBtnSelect
                                         completion:^(QYZYSubMatchModel * _Nonnull model) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        self.guessMatchModel = model;
        self.guessMatchModel.sportId = self.detailModel.sportId;
        [self.tableView reloadData];
    }];
    
    [self.viewModel requestMatchAnalyzeIntegralWithMatchId:self.detailModel.matchId hostTeamId:self.detailModel.hostTeamId guestTeamId:self.detailModel.guestTeamId completion:^(QYZYMatchAnalyzeRankModel * _Nonnull analyzeRankModel) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        if (analyzeRankModel) {
            self.rankModel = analyzeRankModel;
            [self.tableView reloadData];
        }
    }];
    
    /// 主队未来赛程
    [self.viewModel requestMatchFutureRecordsWithMatchId:self.detailModel.matchId teamId:self.detailModel.hostTeamId completion:^(NSArray<QYZYMatchMainModel *> * _Nonnull matches) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        if (matches) {
            self.hostFutureArray = matches;
            [self.tableView reloadData];
        }
    }];
    /// 客队未来赛程
    [self.viewModel requestMatchFutureRecordsWithMatchId:self.detailModel.matchId teamId:self.detailModel.guestTeamId completion:^(NSArray<QYZYMatchMainModel *> * _Nonnull matches) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        if (matches) {
            self.guestFutureArray = matches;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据~" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} ];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_noData"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYMatchAnalyzeSuperCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYMatchAnalyzeSuperCell.class)];
    cell.subType = (QYZYAnalyzeSubType)indexPath.section;
    cell.isBasket = self.viewModel.isBasket;
    if (indexPath.section == 0) {
        QYZYAnalyzeSectionModel *model = self.sections[indexPath.section];
        if (model.isHomeAwayBtnSelect) {
            cell.rankArray = self.rankModel.sameHostGuest;
        }else {
            cell.rankArray = self.rankModel.all;
        }
    }
    if (indexPath.section == 1) {
        cell.historyMatchModel = self.historyMatchModel;
    }
    if (indexPath.section == 2) {
        cell.hostMatchModel = self.hostMatchModel;
    }
    if (indexPath.section == 3) {
        cell.guessMatchModel = self.guessMatchModel;
    }
    if (indexPath.section == 4) {
        cell.hostFutureArray = self.hostFutureArray;
    }
    if (indexPath.section == 5) {
        cell.guestFutureArray = self.guestFutureArray;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QYZYAnalyzeSectionModel *model = self.sections[indexPath.section];
        if (model.isHomeAwayBtnSelect) {
            return self.rankModel.sameHostGuest.count ? self.rankModel.sameHostGuest.count * 40 + 40 : 0.01;
        }else {
            return self.rankModel.all.count ? self.rankModel.all.count * 40 + 40 : 0.01;
        }
    }
    if (indexPath.section == 1) {
        return self.historyMatchModel.matches.count > 0 ? self.historyMatchModel.matches.count * 40 + 80 : 0.01;
    }
    if (indexPath.section == 2) {
        return self.hostMatchModel.matches.count > 0 ? self.hostMatchModel.matches.count * 40 + 80 : 0.01;
    }
    if (indexPath.section == 3) {
        return self.guessMatchModel.matches.count > 0 ? self.guessMatchModel.matches.count * 40 + 80 : 0.01;
    }
    if (indexPath.section == 4) {
        return self.hostFutureArray.count ? self.hostFutureArray.count * 42 + 40 : 0.01;
    }
    if (indexPath.section == 5) {
        return self.guestFutureArray.count ? self.guestFutureArray.count * 42 + 40 : 0.01;
    }
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    QYZYAnalyzeHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(QYZYAnalyzeHeaderFooterView.class)];
    QYZYAnalyzeSectionModel *model = self.sections[section];
    
    view.titleLabel.text = self.groups[section];
    weakSelf(self)
    view.matchBlock = ^(UIButton * _Nonnull btn) {
        strongSelf(self)
        model.isMatchBtnSelect = !btn.selected;
        [self handleSectionModel:section model:model];
        [self requestData];
    };
    
    view.hostGuessBlock = ^(UIButton * _Nonnull btn) {
        model.isHomeAwayBtnSelect = !btn.selected;
        [self handleSectionModel:section model:model];
        [self requestData];
    };
    view.model = model;
    return view;
    
}

- (void)handleSectionModel:(NSInteger)section model:(QYZYAnalyzeSectionModel *)model {
    QYZYAnalyzeSectionModel *tempModel = [[QYZYAnalyzeSectionModel alloc] init];
    tempModel.isMatchBtnSelect = model.isMatchBtnSelect;
    tempModel.isHomeAwayBtnSelect = model.isHomeAwayBtnSelect;
    tempModel.isMatchBtnHidden = model.isMatchBtnHidden;
    tempModel.isHomeAwayBtnHidden = model.isHomeAwayBtnHidden;
    [self.sections replaceObjectAtIndex:section withObject:tempModel];
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
        _tableView.sectionFooterHeight = 0.1;
        weakSelf(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongSelf(self)
            [self requestData];
        }];
 
        _tableView.mj_footer.hidden = YES;
        [_tableView registerClass:[QYZYMatchAnalyzeSuperCell class] forCellReuseIdentifier:NSStringFromClass(QYZYMatchAnalyzeSuperCell.class)];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYAnalyzeHeaderFooterView.class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(QYZYAnalyzeHeaderFooterView.class)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}

- (QYZYMatchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYMatchViewModel alloc] init];
    }
    return _viewModel;
}

- (QYZYSubMatchModel *)historyMatchModel {
    if (!_historyMatchModel) {
        _historyMatchModel = [[QYZYSubMatchModel alloc] init];
    }
    return _historyMatchModel;
}

- (QYZYSubMatchModel *)guessMatchModel {
    if (!_guessMatchModel) {
        _guessMatchModel = [[QYZYSubMatchModel alloc] init];
    }
    return _guessMatchModel;
}

- (QYZYSubMatchModel *)hostMatchModel {
    if (!_hostMatchModel) {
        _hostMatchModel = [[QYZYSubMatchModel alloc] init];
    }
    return _hostMatchModel;
}

@end
