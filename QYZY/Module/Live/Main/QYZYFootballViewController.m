//
//  QYZYFootballViewController.m
//  QYZY
//
//  Created by jspatches on 2022/9/29.
//

#import "QYZYFootballViewController.h"
#import "QYZYScheduleHeaderVIew.h"
#import "QYZYScheduleTableViewCell.h"
#import "QYZYFootballViewModel.h"
#import "QYZYAppointmentViewController.h"
#import "QYZYPhoneLoginViewController.h"

@interface QYZYFootballViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * headSectionArr;
@property (nonatomic, strong) QYZYFootballViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *mutableArray;
@end

@implementation QYZYFootballViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _headSectionArr = [NSArray arrayWithObjects:[self getCurrentTimes], nil];
    [self requestGroup];
}


#pragma mark - get network
- (void)requestGroup {
    
    self.viewModel.sportType = 1;
    [self.viewModel requestGroupListWithCompletion:^(NSArray<QYZYMatchListInfoDetailModel *> * _Nonnull groupArray) {
        [self.mutableArray removeAllObjects];
        [self.tableView.mj_header endRefreshing];
        
        if (groupArray.count != 0) {
            self.mutableArray =(NSMutableArray *)groupArray;
            [self addConstraintsAndActions];
        }
        [self.tableView reloadData];
    }];
    
}

- (void)requestappointmenttotheWithIndexPath:(NSIndexPath *)indexPath model:(QYZYMatchListInfoDetailModel *)model
{
    BOOL isBook = !model.userIsAppointment;
    if (QYZYUserManager.shareInstance.isLogin == false) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [self presentViewController:vc animated:true completion:nil];
        });
        
        return;
    }
    
    
    [self.viewModel requestappointmenttothegameCompletion:^(NSString * _Nullable msg) {
        if (!msg) {
            [self.view qyzy_showMsg:isBook ? @"预约成功!" : @"取消成功!"];
            model.userIsAppointment = !model.userIsAppointment;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        else {
            [self.view qyzy_showMsg:msg];
        }
    } isBook:isBook];
}


#pragma mark - layout
- (void)addConstraintsAndActions
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-0);
        make.bottom.mas_equalTo(-TabBarHeight);
        make.top.mas_equalTo(NavigationBarHeight-30);
    }];
}

#pragma mark - delegateMethod

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    weakSelf(self);
    QYZYScheduleTableViewCell *cell = [[QYZYScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYScheduleTableViewCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    QYZYMatchListInfoDetailModel *model = self.mutableArray[indexPath.row];
    [cell updataUI:model];
    
    [cell setActionBlock:^{
        NSLog(@"点击预约");
        self.viewModel.leagueId = (NSNumber *)model.matchId;
        [weakself requestappointmenttotheWithIndexPath:indexPath model:model];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
   
}


//iOS11之后需要调用下面2个viewForHeader、viewForFooter代理方法才能对header、footer高度设置起作用
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QYZYScheduleHeaderVIew *headerView = [[QYZYScheduleHeaderVIew alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 30)];
    headerView.titleLabel.text = self.headSectionArr[section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}




#pragma mark - creatUI lazy

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[QYZYScheduleTableViewCell class] forCellReuseIdentifier:@"QYZYScheduleTableViewCell"];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf(self);
            [weakself requestGroup];
        }];
        
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

- (QYZYFootballViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[QYZYFootballViewModel alloc]init];
    }
    
    return _viewModel;
}


- (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateNow = [NSDate date];
    NSString *currentTime = [formatter stringFromDate:dateNow];
    return currentTime;

}
@end
