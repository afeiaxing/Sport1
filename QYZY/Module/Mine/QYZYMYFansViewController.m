//
//  QYZYMYFansViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYMYFansViewController.h"
#import "QYZYMyattentionTableViewCell.h"
#import "QYZYMyattentionModel.h"
#import "QYZYPersonalhomepageViewController.h"
#import "QYZYAppointmentViewMoel.h"
#import "QYZYfansApi.h"
#import "QYZYNewsPostAttentionApi.h"
#import "QYZYNewsPostAttentionCancelApi.h"

@interface QYZYMYFansViewController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)QYZYAppointmentViewMoel *viewModel;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation QYZYMYFansViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestGroup];
    self.view.backgroundColor = rgb(247, 248, 254);
    self.tableView.backgroundColor = rgb(247, 248, 254);
    [self addConstraintsAndActions];
}

#pragma mark - get network
- (void)requestGroup {

    weakSelf(self);
    
    QYZYfansApi *minApi = [QYZYfansApi new];
    
    [minApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.array = [NSArray yy_modelArrayWithClass:[QYZYMyattentionModel class] json:request.responseObject[@"data"][@"list"]];
        [weakself.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
}

- (void)loadAttentionWithModel:(QYZYMyattentionModel *)model {
    QYZYNewsPostAttentionApi *api = [[QYZYNewsPostAttentionApi alloc] init];
    api.userId = model.userId;
    weakSelf(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        model.isAttention = YES;
        [self.view qyzy_showMsg:@"关注成功"];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.view qyzy_showMsg:@"关注失败"];
    }];
}

- (void)loadAttentionCancelWithModel:(QYZYMyattentionModel *)model {
    QYZYNewsPostAttentionCancelApi *api = [[QYZYNewsPostAttentionCancelApi alloc] init];
    api.userId = model.userId;
    weakSelf(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        model.isAttention = NO;
        [self.view qyzy_showMsg:@"取消关注成功"];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.view qyzy_showMsg:@"取消关注失败"];
    }];
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

#pragma mark - delegateMethod

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    weakSelf(self);
    QYZYMyattentionTableViewCell *cell = [[QYZYMyattentionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYScheduleTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (!cell) {
        cell = [[QYZYMyattentionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYMyattentionTableViewCell"];
    }
    cell.focusBlock = ^(QYZYMyattentionModel * _Nonnull model) {
        strongSelf(self);
        model.isAttention ? [self loadAttentionCancelWithModel:model] : [self loadAttentionWithModel:model];
    };
    QYZYMyattentionModel *model = self.array[indexPath.row];
    [cell updataUI:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    QYZYMyattentionModel *model = self.array[indexPath.row];
    QYZYPersonalhomepageViewController *vc = [[QYZYPersonalhomepageViewController alloc]init];
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


#pragma mark - creatUI lazy

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[QYZYMyattentionTableViewCell class] forCellReuseIdentifier:@"QYZYMyattentionTableViewCell"];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}




- (QYZYAppointmentViewMoel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[QYZYAppointmentViewMoel alloc]init];
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
