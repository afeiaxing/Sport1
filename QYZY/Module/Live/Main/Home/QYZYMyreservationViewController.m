//
//  QYZYMyreservationViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYMyreservationViewController.h"
#import "QYZYScheduleTableViewCell.h"
#import "QYZYAppointmentViewMoel.h"

@interface QYZYMyreservationViewController ()<UITableViewDelegate,UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * headSectionArr;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@property (nonatomic, strong) QYZYAppointmentViewMoel *viewModel;

@end

@implementation QYZYMyreservationViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addConstraintsAndActions];
    // Do any additional setup after loading the view.
    [self requestGroup];
}


#pragma mark - get network
- (void)requestGroup {
    [self.viewModel requestGroupListWithCompletion:^(NSArray<QYZYMyreserModel *> * _Nonnull groupArray) {
        if (groupArray.count != 0) {
            self.mutableArray =(NSMutableArray *)groupArray;
        }
        [self.tableView reloadData];
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
    QYZYScheduleTableViewCell *cell = [[QYZYScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYScheduleTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (!cell) {
        cell = [[QYZYScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYScheduleTableViewCell"];
    }
    QYZYMyreserModel *model = [QYZYMyreserModel yy_modelWithDictionary:self.mutableArray[indexPath.row]];
    model.userIsAppointment = true;
    [cell myreserDataUI:model];
    
    [cell setActionBlock:^{
        NSLog(@"点击关注");
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        _tableView.backgroundColor  = rgb(247, 248, 254);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[QYZYScheduleTableViewCell class] forCellReuseIdentifier:@"QYZYScheduleTableViewCell"];
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
