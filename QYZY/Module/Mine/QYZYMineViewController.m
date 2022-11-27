//
//  QYZYMineViewController.m
//  QYZY
//
//  Created by jsmaster on 9/27/22.
//

#import "QYZYMineViewController.h"
#import "QYZYTableHadeView.h"
#import "QYZYMineTableViewCell.h"
#import "QYZYMineCell.h"
#import "QYZYPiecewiseTableViewCell.h"
#import "QYZYTopBlocksModel.h"
#import "QYZYNewsTableViewCell.h"
#import "QYZYHotNewsApi.h"
#import "QYZYNewsDetailViewController.h"
#import "QYZYMIneApi.h"
#import "QYZYMineModel.h"
#import "QYZYAmountwithApi.h"
#import "QYZYAmountwithModel.h"
#import "QYZYPhoneLoginViewController.h"
#import "QYZYPersonalhomepageViewController.h"
#import "QYZYPostApi.h"
#import "QYZYCircleContentModel.h"
#import "QYZYCircleCell.h"
#import "QYZYAppointmentViewController.h"
#import "QYZYSettViewController.h"
#import "QYZYPayattentionFansViewController.h"
#import "QYZYCustomerserviceViewController.h"
#import "QYZYCustomNavigationController.h"
#import "QYZYMycollectionViewController.h"
#import "QYZYQaViewController.h"
#import "QYZYNodataTableViewCell.h"
#import "QYZYChargeViewController.h"

@interface QYZYMineViewController ()<QMUITableViewDelegate,QMUITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong)QMUITableView *tableview;
@property (nonatomic,strong)QYZYTableHadeView *hadeView;
@property (nonatomic,strong) NSMutableArray *mutableArray;
@property (nonatomic,strong) NSArray *postMutableArray;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *imageArray;
@property(nonatomic, assign) NSUInteger pageNum;
@property(nonatomic, strong) NSMutableArray <QYZYTopBlocksModel *> *topNewsModels;
@property(nonatomic, strong) NSMutableArray <QYZYTopBlocksModel *> *newsModels;
@property (nonatomic, assign)BOOL ispost;
@end

@implementation QYZYMineViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ispost = YES;
    [self addConstraintsAndActions];
    self.fd_prefersNavigationBarHidden = YES;
    if ([QYZYUserManager.shareInstance isLogin]) {
        [self.hadeView updataUI:QYZYUserManager.shareInstance.mineModel];
    }
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:QYZYIAPPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:QYZYLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitData) name:QYZYExitLoginSuccessNotification object:nil];
}

- (void)update {
    [self loadData];
}

- (void)exitData
{
    self.postMutableArray = nil;
    [self.tableview reloadData];
    [self.hadeView exit];
}

- (void)loadData {
    QYZYAmountwithApi *amountApi = [QYZYAmountwithApi new];
    [amountApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYAmountwithModel *model = [QYZYAmountwithModel yy_modelWithJSON:[request.responseObject objectForKey:@"data"]];
        
        QYZYUserModel *userModel = QYZYUserManager.shareInstance.userModel;
        userModel.balance = model.balance;
        [QYZYUserManager.shareInstance saveUserModel:userModel];
        
        [self.hadeView updataAmount:model];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
    QYZYMIneApi *minApi = [QYZYMIneApi new];
    minApi.uid = [QYZYUserManager shareInstance].userModel.uid;
    [minApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        QYZYMineModel *model = [QYZYMineModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        [self.hadeView updataUI:model];
        [QYZYUserManager.shareInstance saveMineModel:model];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
    
    if (self.pageNum == 1) {
        [self.topNewsModels removeAllObjects];
        [self.newsModels removeAllObjects];
        self.postMutableArray = nil;
    }
    
    
    QYZYPostApi *postApi = [QYZYPostApi new];
    postApi.authorId =  [NSString stringWithFormat:@"%@",[QYZYUserManager shareInstance].userModel.uid];
    postApi.pageNum = self.pageNum;
    postApi.pageSize = 15;
    [postApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[QYZYCircleContentModel class] json:request.responseObject[@"data"][@"list"]];
        self.postMutableArray = array;
        [self updataTableViewCell];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
    
    QYZYHotNewsApi *api = [QYZYHotNewsApi new];
    api.pageNum = self.pageNum;
    api.pageSize = 15;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.topNewsModels addObjectsFromArray: [NSArray yy_modelArrayWithClass:QYZYTopBlocksModel.class json:[[request.responseObject valueForKey:@"data"] valueForKey:@"newsTopBlocks"]]];
        [self.newsModels addObjectsFromArray: [NSArray yy_modelArrayWithClass:QYZYTopBlocksModel.class json:[[[request.responseObject valueForKey:@"data"] valueForKey:@"news"] valueForKey:@"list"]]];
        
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    
        [self updataTableViewCell];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
}


#pragma mark - layout
- (void)addConstraintsAndActions {
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - delegateMethod

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
    if (section == 2) {
        if (self.ispost == YES) {
            if (self.postMutableArray.count != 0) {
                return self.postMutableArray.count;
            }
            else
            {
                return 1;
            }
        }
        else
        {
            return self.topNewsModels.count + self.newsModels.count;
        }
        
    }
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    weakSelf(self);
    
    QYZYMineCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYMineCell.class) forIndexPath:indexPath];
    if (self.titleArray.count > indexPath.row) {
        cell.titleLabel.text = self.titleArray[indexPath.row];
        cell.iconView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    }
    return cell;
    
//    if (indexPath.section == 0) {
//        QYZYMineTableViewCell *cell = [[QYZYMineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYMineTableViewCell"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell setActionBlock:^(NSInteger tag) {
//            NSLog(@"%ld",(long)tag);
//            if (tag == 0) {
//                if (QYZYUserManager.shareInstance.isLogin == false)
//                {
//                    [weakself islogin];
//                }
//                else
//                {
//                    QYZYMycollectionViewController *vc = [[QYZYMycollectionViewController alloc]init];
//                    [weakself.navigationController pushViewController:vc animated:YES];
//                }
//
//            }
//            if (tag == 1) {
//                if (QYZYUserManager.shareInstance.isLogin == false)
//                {
//                    [weakself islogin];
//                }
//                else
//                {
//                    QYZYAppointmentViewController *vc = [[QYZYAppointmentViewController alloc]init];
//                    [weakself.navigationController pushViewController:vc animated:YES];
//                }
//            }
//            if (tag == 2) {
//                QYZYQaViewController *vc = [[QYZYQaViewController alloc]init];
//                [weakself.navigationController pushViewController:vc animated:YES];
//            }
//
//        }];
//        return cell;
//    }
//    if (indexPath.section == 1) {
//
//        QYZYPiecewiseTableViewCell *cell = [[QYZYPiecewiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYPiecewiseTableViewCell"];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell ispost:self.ispost];
//        [cell setButtonBlock:^(UIButton * _Nonnull button) {
//            if (button == cell.postButton) {
//                NSLog(@"帖子");
//                self.ispost = YES;
//            }
//            else
//            {
//                NSLog(@"文章");
//                self.ispost = NO;
//            }
//
//            [self updataTableViewCell];
//        }];
//
//
//        return cell;
//    }
//
//    if (indexPath.section == 2) {
//
//        if (self.ispost == YES) {
//
//            if (self.postMutableArray.count != 0) {
//                QYZYCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYCircleCell" forIndexPath:indexPath];
//                cell.model = self.postMutableArray[indexPath.row];
//                return cell;
//            }
//            else
//            {
//
//                QYZYNodataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYNodataTableViewCell" forIndexPath:indexPath];
//                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//                return cell;
//            }
//
//        }
//        else
//        {
//            QYZYNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
//
//            NSMutableArray *array = [NSMutableArray array];
//            [array addObjectsFromArray:self.topNewsModels];
//            [array addObjectsFromArray:self.newsModels];
//            cell.model = array[indexPath.row];
//            return cell;
//        }
//    }
//
//    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        return 76;
        return 54;
    }
    if (indexPath.section == 1) {
        return 58;
    }
    if (indexPath.section == 2) {
        if (self.ispost == YES) {
            if (self.postMutableArray.count != 0) {
                return 180;
            }
            else
            {
                return 350;
            }
        }
        else
        {
            return 106;
        }
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            QYZYQaViewController *vc = [[QYZYQaViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        if (!QYZYUserManager.shareInstance.isLogin) {
            [self islogin];
            return;
        }
        if (indexPath.row == 0) {
            QYZYAppointmentViewController *vc = [[QYZYAppointmentViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            QYZYMycollectionViewController *vc = [[QYZYMycollectionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (indexPath.section == 2) {
        if (self.ispost == YES) {
            
        }
        else
        {
            QYZYNewsDetailViewController *vc = [[QYZYNewsDetailViewController alloc] initWithNibName:NSStringFromClass(QYZYNewsDetailViewController.class) bundle:nil];
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:self.topNewsModels];
            [array addObjectsFromArray:self.newsModels];
            QYZYTopBlocksModel *model = array[indexPath.row];
            vc.newsId = model.newsId;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
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
        _tableview.tableHeaderView = self.hadeView;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerClass:[QYZYMineTableViewCell class] forCellReuseIdentifier:@"QYZYMineTableViewCell"];
        [_tableview registerClass:[QYZYPiecewiseTableViewCell class] forCellReuseIdentifier:@"QYZYPiecewiseTableViewCell"];
        [_tableview registerClass:[QYZYNodataTableViewCell class] forCellReuseIdentifier:@"QYZYNodataTableViewCell"];
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYNewsTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYCircleCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYCircleCell.class)];
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYMineCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYMineCell.class)];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.pageNum = 1;
//        self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            self.pageNum++;
//            [self loadData];
//        }];
//        self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            self.pageNum = 1;
//            [self loadData];
//        }];
        
    }
    return _tableview;
}

- (QYZYTableHadeView *)hadeView
{
    weakSelf(self);
    
    if (!_hadeView) {
        _hadeView = [[QYZYTableHadeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 272 + StatusBarHeight)];
        
        //登录
        [_hadeView setActionBlock:^{
            [weakself islogin];
        }];
        //个人主页
        [_hadeView setPushBlock:^{
            
            if (QYZYUserManager.shareInstance.isLogin == false)
            {
                [weakself islogin];
            }
            else
            {
                QYZYPersonalhomepageViewController *vc = [[QYZYPersonalhomepageViewController alloc]init];
                vc.authorId = [NSString stringWithFormat:@"%@",[QYZYUserManager shareInstance].userModel.uid];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        
        }];
        
//        //关注粉丝
        [_hadeView setUpBlock:^{
            
            if (QYZYUserManager.shareInstance.isLogin == false)
            {
                [weakself islogin];
            }
            else
            {
                QYZYPayattentionFansViewController * vc = [[QYZYPayattentionFansViewController alloc]init];
                [weakself.navigationController pushViewController:vc animated:YES];
            }
        }];
        
        //设置
        [_hadeView setSetupBlock:^{
            
            if (QYZYUserManager.shareInstance.isLogin == false)
            {
                [weakself islogin];
            }
            else
            {
                QYZYSettViewController *setVC = [[QYZYSettViewController alloc]init];
                [weakself.navigationController pushViewController:setVC animated:YES];
            }
           
        }];
        
        [_hadeView setTopupBlock:^{
            if (QYZYUserManager.shareInstance.isLogin == false)
            {
                [weakself islogin];
            }
            else
            {
                QYZYChargeViewController *chargeVC = [[QYZYChargeViewController alloc] init];
                chargeVC.hidesBottomBarWhenPushed = true;
                [weakself.navigationController pushViewController:chargeVC animated:YES];
            }
        }];
        
    }
    return _hadeView;
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

- (NSArray *)postMutableArray
{
    if (!_postMutableArray) {
        _postMutableArray = [[NSArray alloc]init];
    }
    return _postMutableArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSArray arrayWithObjects:@"我的预约",@"我的收藏",@"常见问题", nil];
    }
    return _titleArray;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSArray arrayWithObjects:@"iconMeYuey",@"iconMeSc",@"iconMeWenti", nil];
    }
    return _imageArray;
}

- (void)updataTableViewCell
{
    NSInteger section = [self.tableview numberOfSections];
    if (section > 2) {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [self.tableview reloadSections:indexSet withRowAnimation: UITableViewRowAnimationNone];
    }
}


- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    if(@available(iOS 13.0, *)) {
        
        static UIView *statusBar =nil;
        if(!statusBar) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                statusBar = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                statusBar.backgroundColor= color;
                
            });
        }else{
            statusBar.backgroundColor= color;
        }
    }else{
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor= color;
        }
    }
}


- (void)islogin
{
    if (QYZYUserManager.shareInstance.isLogin == false) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [self presentViewController:vc animated:true completion:nil];
        });
    }
}





@end
