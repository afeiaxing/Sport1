//
//  QYZYMyattentionViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYMyattentionViewController.h"
#import "QYZYAppointmentViewMoel.h"
#import "QYZYMyattentionTableViewCell.h"
#import "QYZYMyattentionModel.h"
#import "QYZYPersonalhomepageViewController.h"
#import "QYZYNewsPostAttentionApi.h"
#import "QYZYNewsPostAttentionCancelApi.h"

@interface QYZYMyattentionViewController ()<UITableViewDataSource,UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)QYZYAppointmentViewMoel *viewModel;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) UITableView * tableView;
@end

@implementation QYZYMyattentionViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addConstraintsAndActions];
    // Do any additional setup after loading the view.
    [self requestGroup];
    self.view.backgroundColor = rgb(247, 248, 254);
    self.tableView.backgroundColor = rgb(247, 248, 254);
}


#pragma mark - get network
- (void)requestGroup {
    
    
    [self.viewModel requestAttentionCompletion:^(NSArray<QYZYMyreserModel *> * _Nonnull groupArray) {
        if (groupArray.count != 0) {
            self.mutableArray =(NSMutableArray *)groupArray;
        }
        [self.tableView reloadData];
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
        [self.mutableArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[NSString stringWithFormat:@"%@",[obj valueForKey:@"userId"]] isEqualToString:model.userId]) {
                [obj setValue:@YES forKey:@"isAttention"];
            }
        }];
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
        [self.mutableArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([[NSString stringWithFormat:@"%@",[obj valueForKey:@"userId"]] isEqualToString:model.userId]) {
                [obj setValue:@NO forKey:@"isAttention"];
            }
        }];
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
    return self.mutableArray.count;
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
    QYZYMyattentionModel *model = [QYZYMyattentionModel yy_modelWithDictionary:self.mutableArray[indexPath.row]];
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
    
    QYZYMyattentionModel *model = [QYZYMyattentionModel yy_modelWithDictionary:self.mutableArray[indexPath.row]];
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
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[QYZYMyattentionTableViewCell class] forCellReuseIdentifier:@"QYZYMyattentionTableViewCell"];
    }
    return _tableView;
}


- (NSMutableArray *)mutableArray
{
    if (!_mutableArray) {
        _mutableArray = [[NSMutableArray alloc]init];
    }
    return _mutableArray;
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
