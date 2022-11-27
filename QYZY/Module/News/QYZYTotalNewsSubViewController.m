//
//  QYZYTotalNewsSubViewController.m
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import "QYZYTotalNewsSubViewController.h"
#import "QYZYNewsDetailViewController.h"
#import "QYZYNewsTableViewCell.h"

#import "QYZYTotalNewsApi.h"
#import "QYZYTopBlocksModel.h"

@interface QYZYTotalNewsSubViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic, assign) NSUInteger pageNum;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *totalNewsModels;

@end

@implementation QYZYTotalNewsSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUI];
}

- (UIView *)listView {
    return self.view;
}

- (void)setupUI {
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYNewsTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageNum++;
        [self loadData];
    }];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self loadData];
    }];
    self.tableview.emptyDataSetSource = self;
    self.tableview.emptyDataSetDelegate = self;
}

- (void)loadData {
    if (self.pageNum == 1) {
        [self.totalNewsModels removeAllObjects];
    }
    QYZYTotalNewsApi *api = [QYZYTotalNewsApi new];
    api.pageNum = self.pageNum;
    api.pageSize = 15;
    api.mediaType = self.model.mediaType;
    api.categoryId = self.model.categoryId;
    api.sportType = self.model.sportType;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        [self.totalNewsModels addObjectsFromArray: [NSArray yy_modelArrayWithClass:QYZYTopBlocksModel.class json:[[request.responseObject valueForKey:@"data"] valueForKey:@"list"]]];

        [self.tableview reloadData];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalNewsModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
    cell.model = self.totalNewsModels[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYNewsDetailViewController *vc = [[QYZYNewsDetailViewController alloc] initWithNibName:NSStringFromClass(QYZYNewsDetailViewController.class) bundle:nil];
    QYZYTopBlocksModel *model = self.totalNewsModels[indexPath.row];
    vc.newsId = model.newsId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Set
- (void)setModel:(QYZYTotalNewsLabelModel *)model {
    _model = model;
    self.pageNum = 1;
    [self loadData];
}

#pragma mark - Get
- (NSMutableArray *)totalNewsModels {
    if (!_totalNewsModels) {
        _totalNewsModels = [NSMutableArray array];
    }
    return _totalNewsModels;
}
@end
