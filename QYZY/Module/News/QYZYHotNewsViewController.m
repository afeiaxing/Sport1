//
//  QYZYHotNewsViewController.m
//  QYZY
//
//  Created by jsmaster on 10/1/22.
//

#import "QYZYHotNewsViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "QYZYNewsTableViewCell.h"
#import "QYZYHotNewsApi.h"
#import "QYZYTopBlocksModel.h"
#import "QYZYNewsDetailViewController.h"

@interface QYZYHotNewsViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic, assign) NSUInteger pageNum;
@property(nonatomic, strong) NSMutableArray <QYZYTopBlocksModel *> *topNewsModels;
@property(nonatomic, strong) NSMutableArray <QYZYTopBlocksModel *> *newsModels;
@property(nonatomic, strong) NSArray <QYZYTopBlocksModel *> *topModels;

@end

@implementation QYZYHotNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:QYZYNetworkingFirstAvaliableNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    self.pageNum = 1;
    [self.view addSubview:self.cycleScrollView];
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
        [self.topNewsModels removeAllObjects];
        [self.newsModels removeAllObjects];
    }
    QYZYHotNewsApi *api = [QYZYHotNewsApi new];
    api.pageNum = self.pageNum;
    api.pageSize = 15;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <QYZYTopBlocksModel *> *topModels = [NSArray yy_modelArrayWithClass:QYZYTopBlocksModel.class json:[[request.responseObject valueForKey:@"data"] valueForKey:@"topBlocks"]];
        self.cycleScrollView.imageURLStringsGroup = [topModels qmui_mapWithBlock:^id _Nonnull(QYZYTopBlocksModel * _Nonnull item) {
            return item.imgUrl;
        }];
        self.cycleScrollView.titlesGroup = [topModels qmui_mapWithBlock:^id _Nonnull(QYZYTopBlocksModel * _Nonnull item) {
            return item.title;
        }];
        self.topModels = topModels;
        
        [self.topNewsModels addObjectsFromArray: [NSArray yy_modelArrayWithClass:QYZYTopBlocksModel.class json:[[request.responseObject valueForKey:@"data"] valueForKey:@"newsTopBlocks"]]];
        [self.newsModels addObjectsFromArray: [NSArray yy_modelArrayWithClass:QYZYTopBlocksModel.class json:[[[request.responseObject valueForKey:@"data"] valueForKey:@"news"] valueForKey:@"list"]]];
        
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        [self.tableview reloadData];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topNewsModels.count + self.newsModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.topNewsModels];
    [array addObjectsFromArray:self.newsModels];
    cell.model = array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYNewsDetailViewController *vc = [[QYZYNewsDetailViewController alloc] initWithNibName:NSStringFromClass(QYZYNewsDetailViewController.class) bundle:nil];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.topNewsModels];
    [array addObjectsFromArray:self.newsModels];
    QYZYTopBlocksModel *model = array[indexPath.row];
    vc.newsId = model.newsId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    QYZYNewsDetailViewController *vc = [[QYZYNewsDetailViewController alloc] initWithNibName:NSStringFromClass(QYZYNewsDetailViewController.class) bundle:nil];
    QYZYTopBlocksModel *model = self.topModels[index];
    vc.newsId = model.jumpId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据~" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} ];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_noData"];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - setter&getter
- (SDCycleScrollView *)cycleScrollView {
    if (_cycleScrollView == nil) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 175) delegate:self placeholderImage:[UIImage imageNamed:@"logo_placeholder"]];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.imageURLStringsGroup = @[];
    }
    return _cycleScrollView;
}

- (NSMutableArray<QYZYTopBlocksModel *> *)newsModels {
    if (_newsModels == nil) {
        _newsModels = [NSMutableArray array];
    }
    return _newsModels;
}

- (NSMutableArray<QYZYTopBlocksModel *> *)topNewsModels {
    if (_topNewsModels == nil) {
        _topNewsModels = [NSMutableArray array];
    }
    return _topNewsModels;
}

@end
