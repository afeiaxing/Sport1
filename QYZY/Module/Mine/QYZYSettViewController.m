//
//  QYZYSettViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYSettViewController.h"
#import "QYZYSetTableViewCell.h"
#import "QYZYExitAPi.h"
#import "QYZYCancellationViewController.h"

NSString * const QYZYExitLoginSuccessNotification = @"com.qyzy.exitlogin.success";

@interface QYZYSettViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong)UITableView *setTableView;
@property (nonatomic ,strong)NSArray *titleArray;
@property (nonatomic ,strong)UIButton *ExitButton;
@property (nonatomic ,strong)UIView *footView;
@end

@implementation QYZYSettViewController

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
    self.title = @"设置";
    [self addConstraintsAndActions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitData) name:QYZYExitLoginSuccessNotification object:nil];
    
    
}

- (void)exitData
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - layout
- (void)addConstraintsAndActions
{
    [self.view addSubview:self.setTableView];
    [self.setTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.footView addSubview:self.ExitButton];
    [self.ExitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(60);
    }];
    
}

- (void)exitClick:(UIButton *)button
{
    weakSelf(self);
    
    QYZYExitAPi *minApi = [QYZYExitAPi new];
    [minApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [QYZYUserManager shareInstance].userModel = nil;
        self.tabBarController.selectedIndex = 0;
        [QYZYUserManager.shareInstance saveUserModel:[QYZYUserManager shareInstance].userModel];
        [weakself.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:QYZYExitLoginSuccessNotification object:nil];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
}


#pragma mark - delegateMethod


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYZYSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYSetTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = self.titleArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.rigLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        QYZYCancellationViewController *vc = [[QYZYCancellationViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (UITableView *)setTableView{
    if (!_setTableView) {
        _setTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _setTableView.delegate = self;
        _setTableView.dataSource = self;
        _setTableView.estimatedSectionHeaderHeight = 0;
        _setTableView.estimatedSectionFooterHeight = 0;
        _setTableView.showsVerticalScrollIndicator = NO;
        _setTableView.showsHorizontalScrollIndicator = NO;
        _setTableView.tableFooterView = self.footView;
        [_setTableView registerClass:[QYZYSetTableViewCell class] forCellReuseIdentifier:@"QYZYSetTableViewCell"];
    }
    return _setTableView;
}

- (NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[
        @"版本信息",@"注销账户"];
    }
    return _titleArray;
}

- (UIButton *)ExitButton
{
    if (!_ExitButton) {
        _ExitButton = [[UIButton alloc]init];
        [_ExitButton setTitle:@"退出登录" forState:UIControlStateNormal];
        [_ExitButton addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
        [_ExitButton setTitleColor:rgb(255, 255, 255) forState:UIControlStateNormal];
        _ExitButton.backgroundColor = rgb(41, 69, 192);
        _ExitButton.layer.masksToBounds = YES;
        _ExitButton.layer.cornerRadius = 4;
    }
    return _ExitButton;
}

- (UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    }
    return _footView;
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
