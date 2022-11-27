//
//  QYZYPopularListViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYPopularListViewController.h"
#import "QYZYRankTableViewCell.h"
#import "QYZYRankViewModel.h"
#import "QYZYPersonalhomepageViewController.h"

@interface QYZYPopularListViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong) QYZYRankViewModel *viewModel;
@property (nonatomic,strong) NSArray<QYZYRankModel *> *rankArray;

@end

@implementation QYZYPopularListViewController

- (UIView *)listView {
    return self.view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestRankData];
    self.view.backgroundColor = rgb(247, 248, 254);
    self.tableView.backgroundColor = rgb(247, 248, 254);
    [self addConstraintsAndActions];
}

#pragma mark - layout
- (void)addConstraintsAndActions
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.mas_equalTo(0);
    }];
}


- (void)requestRankData {
    weakSelf(self);
    [self.viewModel requestRankDataWithtype:@(3) isDay:YES completion:^(NSArray<QYZYRankModel *> * _Nonnull array) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        if (array) {
            self.rankArray = array;
        }
        [self.tableView reloadData];
    
    }];
    
    

}


#pragma mark - delegateMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rankArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    weakSelf(self);
    QYZYRankTableViewCell *cell = [[QYZYRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYRankTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (!cell) {
        cell = [[QYZYRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYRankTableViewCell"];
    }
    QYZYRankModel *model = self.rankArray[indexPath.row];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    [cell updataUI:model isDay:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYZYPersonalhomepageViewController *vc = [[QYZYPersonalhomepageViewController alloc]init];
    QYZYRankModel *model = self.rankArray[indexPath.row];
    vc.authorId = model.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DZNEmptyDataSetSource DZNEmptyDataSetDelegate
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:@"暂无数据~" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} ];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_noData"];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[QYZYRankTableViewCell class] forCellReuseIdentifier:@"QYZYRankTableViewCell"];
    }
    
    return _tableView;
}

- (QYZYRankViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYRankViewModel alloc] init];
    }
    return _viewModel;
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
