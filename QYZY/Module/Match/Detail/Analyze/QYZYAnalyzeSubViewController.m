//
//  QYZYAnalyzeSubViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/14.
//

#import "QYZYAnalyzeSubViewController.h"
#import "QYZYMatchDetailViewController.h"
#import "QYZYMatchCell.h"
#import "QYZYTableEmptyCell.h"
#import "QYZYMatchViewModel.h"

@interface QYZYAnalyzeSubViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) QYZYMatchViewModel *viewModel;
@property (nonatomic ,strong) NSArray<QYZYMatchDetailModel *> *historyArray;
@end

@implementation QYZYAnalyzeSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColor.whiteColor;
    
    weakSelf(self);
    self.tableView.backgroundColor = rgb(248, 249, 254);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self);
        [self requestData];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYMatchCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYMatchCell.class)];
    [self.tableView registerClass:QYZYTableEmptyCell.class forCellReuseIdentifier:NSStringFromClass(QYZYTableEmptyCell.class)];
}

- (UIView *)listView {
    return self.view;
}

- (void)setDetailModel:(QYZYMatchMainModel *)detailModel {
    _detailModel = detailModel;
    self.viewModel.isBasket = ![detailModel.sportId isEqualToString:@"1"];
    [self requestData];
}

- (void)requestData {
//    if (self.subType == AnalyzeSubTypeHistory) {
//        weakSelf(self);
//        [self.viewModel requestAnalyzeHistoryWithMatchId:self.detailModel.matchId hostTeamId:self.detailModel.hostTeamId guestTeamId:self.detailModel.guestTeamId completion:^(NSArray<QYZYMatchDetailModel *> * _Nonnull historyArray) {
//            strongSelf(self);
//            [self.tableView.mj_header endRefreshing];
//            if (historyArray) {
//                self.historyArray = historyArray;
//                [self.tableView reloadData];
//            }
//        }];
//    }
//    else if (self.subType == AnalyzeSubTypeHost) {
//        weakSelf(self);
//        [self.viewModel requestAnalyzeRecentWithMatchId:self.detailModel.matchId teamId:self.detailModel.hostTeamId side:@"host" completion:^(NSArray<QYZYMatchDetailModel *> * _Nonnull historyArray) {
//            strongSelf(self);
//            [self.tableView.mj_header endRefreshing];
//            if (historyArray) {
//                self.historyArray = historyArray;
//                [self.tableView reloadData];
//            }
//        }];
//    }
//    else if (self.subType == AnalyzeSubTypeGuest) {
//        weakSelf(self);
//        [self.viewModel requestAnalyzeRecentWithMatchId:self.detailModel.matchId teamId:self.detailModel.guestTeamId side:@"guest" completion:^(NSArray<QYZYMatchDetailModel *> * _Nonnull historyArray) {
//            strongSelf(self);
//            [self.tableView.mj_header endRefreshing];
//            if (historyArray) {
//                self.historyArray = historyArray;
//                [self.tableView reloadData];
//            }
//        }];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.historyArray.count) {
        QYZYMatchCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYMatchCell.class) forIndexPath:indexPath];
        if (self.historyArray.count > indexPath.row) {
            cell.detailModel = self.historyArray[indexPath.row];
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
    return self.historyArray.count ? self.historyArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.historyArray.count ? 112 : self.view.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.historyArray.count) {
        QYZYMatchDetailViewController *vc = [[QYZYMatchDetailViewController alloc] init];
        vc.matchId = self.historyArray[indexPath.row].matchId;
        vc.hidesBottomBarWhenPushed = YES;
        [UIViewController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}

- (QYZYMatchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYMatchViewModel alloc] init];
    }
    return _viewModel;
}

@end
