//
//  QYZYMycollectionViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYMycollectionViewController.h"
#import "QYZYMycollectApi.h"
#import "QYZYinfoModel.h"
#import "QYZYTopBlocksModel.h"
#import "QYZYNewsTableViewCell.h"
#import "QYZYNewsDetailViewController.h"

@interface QYZYMycollectionViewController ()<QMUITableViewDelegate,QMUITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic,strong)QMUITableView *tableview;
@property(nonatomic, strong) NSMutableArray <QYZYTopBlocksModel *> *newsModels;
@property(nonatomic, assign) NSUInteger pageNum;
@end

@implementation QYZYMycollectionViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{

  self.tabBarController.tabBar.hidden = NO;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self requestGroup];
    [self addConstraintsAndActions];
}


#pragma mark - layout
- (void)addConstraintsAndActions
{
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight);
    }];
}



#pragma mark - get network
- (void)requestGroup {

    weakSelf(self);
    
    if (self.pageNum == 1) {
        [self.newsModels removeAllObjects];
    }
    
    QYZYMycollectApi *api = [QYZYMycollectApi new];
    api.pageNum = self.pageNum;
    api.pageSize = 100;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self.newsModels addObjectsFromArray:[NSArray yy_modelArrayWithClass:QYZYTopBlocksModel.class json: request.responseObject[@"data"][@"list"]]];
        [self.tableview reloadData];
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.newsModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    weakSelf(self);
    QYZYNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.newsModels];
    cell.model = array[indexPath.row];
    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 106;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QYZYNewsDetailViewController *vc = [[QYZYNewsDetailViewController alloc] initWithNibName:NSStringFromClass(QYZYNewsDetailViewController.class) bundle:nil];
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.newsModels];
    QYZYTopBlocksModel *model = array[indexPath.row];
    vc.newsId = model.newsId;
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


- (QMUITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[QMUITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYNewsTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        
        self.pageNum = 1;
//        self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            self.pageNum++;
//            [self requestGroup];
//        }];
        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.pageNum = 1;
            [self requestGroup];
        }];
        
    }
    return _tableview;
}




- (NSMutableArray<QYZYTopBlocksModel *> *)newsModels {
    if (_newsModels == nil) {
        _newsModels = [NSMutableArray array];
    }
    return _newsModels;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
