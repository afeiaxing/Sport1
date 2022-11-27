//
//  QYZYLiveRankSubViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYLiveRankSubViewController.h"
#import "QYZYLiveDetailViewModel.h"
#import "QYZYLiveRankCell.h"
#import "QYZYTableEmptyCell.h"
#import "QYZYNewsPostAttentionApi.h"
#import "QYZYNewsPostAttentionCancelApi.h"

@interface QYZYLiveRankSubViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) QYZYLiveDetailViewModel *viewModel;
@property (nonatomic ,strong) NSArray<QYZYLiveRankModel *> *rankArray;

@end

@implementation QYZYLiveRankSubViewController

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgb(248, 249, 254);
    self.tableView.backgroundColor = rgb(248, 249, 254);
    [self setsubview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginStatus) name:QYZYLoginSuccessNotification object:nil];
    [self requestRankData];
}

- (void)setsubview {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYLiveRankCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYLiveRankCell.class)];
    [self.tableView registerClass:QYZYTableEmptyCell.class forCellReuseIdentifier:NSStringFromClass(QYZYTableEmptyCell.class)];
    weakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self);
        [self requestRankData];
    }];
}

- (void)updateLoginStatus {
    [self requestRankData];
}

- (void)requestRankData {
    weakSelf(self);
    [self.viewModel requestRankDataWithAnchorId:self.anchorId isDay:self.isDay completion:^(NSArray<QYZYLiveRankModel *> * _Nonnull array) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        if (array) {
            self.rankArray = array;
            [self.tableView reloadData];
        }
    }];
}

- (void)loadAttentionWithModel:(QYZYLiveRankModel *)model {
    QYZYNewsPostAttentionApi *api = [[QYZYNewsPostAttentionApi alloc] init];
    api.userId = model.userId;
    weakSelf(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        model.focusStatus = YES;
        [self.view qyzy_showMsg:@"关注成功"];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.view qyzy_showMsg:@"关注失败"];
    }];
}

- (void)loadAttentionCancelWithModel:(QYZYLiveRankModel *)model {
    QYZYNewsPostAttentionCancelApi *api = [[QYZYNewsPostAttentionCancelApi alloc] init];
    api.userId = model.userId;
    weakSelf(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        model.focusStatus = NO;
        [self.view qyzy_showMsg:@"取消关注成功"];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.view qyzy_showMsg:@"取消关注失败"];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rankArray.count) {
        QYZYLiveRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYLiveRankCell.class) forIndexPath:indexPath];
        if (self.rankArray.count > indexPath.row) {
            cell.rankModel = self.rankArray[indexPath.row];
        }
        weakSelf(self);
        cell.focusBlock = ^(QYZYLiveRankModel * _Nonnull model) {
            strongSelf(self);
            model.focusStatus ? [self loadAttentionCancelWithModel:model] : [self loadAttentionWithModel:model];
        };
        return cell;
    }
    else {
        QYZYTableEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYTableEmptyCell.class) forIndexPath:indexPath];
        cell.contentView.backgroundColor = UIColor.whiteColor;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rankArray.count ? self.rankArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.rankArray.count ? 80 : self.view.frame.size.height;
}

- (QYZYLiveDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYLiveDetailViewModel alloc] init];
    }
    return _viewModel;
}

@end
