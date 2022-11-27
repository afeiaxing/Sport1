//
//  QYZYLiveNoticeViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/3.
//

#import "QYZYLiveNoticeViewController.h"
#import "QYZYLiveNoticeApi.h"
#import "QYZYScheduleTableViewCell.h"
#import "QYZYFootballViewModel.h"
#import "QYZYTableEmptyCell.h"

@interface QYZYLiveNoticeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) QYZYFootballViewModel *viewModel;
@property (nonatomic ,strong) NSArray <QYZYMatchListInfoDetailModel *> *dataArray;
@end

@implementation QYZYLiveNoticeViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.tableView registerClass:QYZYScheduleTableViewCell.class forCellReuseIdentifier:NSStringFromClass(QYZYScheduleTableViewCell.class)];
    [self.tableView registerClass:QYZYTableEmptyCell.class forCellReuseIdentifier:NSStringFromClass(QYZYTableEmptyCell.class)];
    self.tableView.backgroundColor = rgb(248, 249, 254);
    weakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self);
        [self requestData];
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 12, 0);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginStatus) name:QYZYLoginSuccessNotification object:nil];
    [self requestData];
}

- (void)updateLoginStatus {
    [self requestData];
}

- (void)requestData {
    QYZYLiveNoticeApi *api = [[QYZYLiveNoticeApi alloc] init];
    api.anchorId = self.anchorId;
    weakSelf(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        NSArray <QYZYMatchListInfoDetailModel *> *dataArray = [NSArray yy_modelArrayWithClass:QYZYMatchListInfoDetailModel.class json:request.responseJSONObject[@"data"]];
        self.dataArray = dataArray;
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)requestBookIsBook:(BOOL)isBook {
    weakSelf(self);
    [self.viewModel requestappointmenttothegameCompletion:^(NSString * _Nullable msg) {
        strongSelf(self);
        if (!msg) {
            [self requestData];
            [self.view qyzy_showMsg:isBook ? @"预约成功!" : @"取消成功!"];
        }
        else {
            [self.view qyzy_showMsg:msg];
        }
    } isBook:isBook];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count) {
        QYZYScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYScheduleTableViewCell.class)];
        cell.scheduleType = ScheduleTypeLiveDetailNotice;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataArray.count > indexPath.row) {
            QYZYMatchListInfoDetailModel * model = self.dataArray[indexPath.row];
            [cell updataUI:model];
            weakSelf(self);
            cell.actionBlock = ^{
                strongSelf(self);
                self.viewModel.leagueId = (NSNumber *)model.matchId;
                [self requestBookIsBook:!model.userIsAppointment];
            };
        }
        return cell;
    }
    else {
        QYZYTableEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYTableEmptyCell.class) forIndexPath:indexPath];
        cell.contentView.backgroundColor = UIColor.whiteColor;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count ? self.dataArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray.count ? 117 : self.view.frame.size.height;
}

- (QYZYFootballViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[QYZYFootballViewModel alloc]init];
    }
    return _viewModel;
}

@end
