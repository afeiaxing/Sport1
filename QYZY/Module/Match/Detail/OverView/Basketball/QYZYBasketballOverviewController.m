//
//  QYZYBasketballOverviewController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYBasketballOverviewController.h"
#import "QYZYBasketballOverViewCell.h"
#import "QYZYBasketBallPointApi.h"
#import "QYZYPeriodModel.h"
#import "QYZYSituationFooterView.h"
#import "QYZYMatchOverHeaderView.h"

@interface QYZYBasketballOverviewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) QYZYSituationFooterView *footerView;

@property (nonatomic, strong) NSMutableArray *vcArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) QYZYMatchOverHeaderView *headerView;

@property (nonatomic, strong) QYZYPeriodModel *periodModel;

@end

@implementation QYZYBasketballOverviewController

#pragma mark - lazy load
- (QYZYSituationFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[QYZYSituationFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _footerView.detailModel = self.detailModel;
        weakSelf(self)
        _footerView.updateFooterHeightBlock = ^(CGFloat height) {
            strongSelf(self)
            self.footerView.frame = CGRectMake(0, 0, ScreenWidth, height);
            [self.tableView reloadData];
        };
    }
    return _footerView;
}

- (QYZYMatchOverHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QYZYMatchOverHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        _headerView.detailModel = self.detailModel;

    }
    return _headerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        weakSelf(self)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongSelf(self)
            [self loadData];
        }];
        [_tableView registerClass:[QYZYBasketballOverViewCell class] forCellReuseIdentifier:@"QYZYBasketballOverViewCell"];
        _tableView.tableFooterView = self.footerView;
        if (self.detailModel.trendAnim.length != 0) {
            _tableView.tableHeaderView = self.headerView;
        }
    }
    return _tableView;
}

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.redColor;
    [self loadData];
    [self setupController];
}

- (void)setupController {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - request
- (void)loadData {
    QYZYBasketBallPointApi *api = [QYZYBasketBallPointApi new];
    api.matchId = self.matchId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self.tableView.mj_header endRefreshing];
        self.periodModel = [QYZYPeriodModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        [self.tableView reloadData];
        [self.footerView reloadData];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYBasketballOverViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYBasketballOverViewCell" forIndexPath:indexPath];
    cell.detailModel = self.detailModel;
    cell.periodModel = self.periodModel;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  95;
}


@end
