//
//  QYZYPersonalhomepageViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYPersonalhomepageViewController.h"
#import "QYZYPersonalHadeView.h"
#import "QYZYTopBlocksModel.h"
#import "QYZYHotNewsApi.h"
#import "QYZYMIneApi.h"
#import "QYZYPiecewiseTableViewCell.h"
#import "QYZYNewsTableViewCell.h"
#import "QYZYMineModel.h"
#import "QYZYNewsDetailViewController.h"
#import "QYZYPostApi.h"
#import "QYZYCircleContentModel.h"
#import "QYZYCircleCell.h"
#import "QYZYNewsPostAttentionCancelApi.h"
#import "QYZYNewsPostAttentionApi.h"
#import "QYZYLiveDetailViewController.h"
#import "QYZYNodataTableViewCell.h"

@interface QYZYPersonalhomepageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)QYZYPersonalHadeView *hadeView;
@property (nonatomic,strong) NSMutableArray *mutableArray;
@property (nonatomic,strong) NSArray *postArray;
@property(nonatomic, assign) NSUInteger pageNum;
@property(nonatomic, strong) NSMutableArray <QYZYTopBlocksModel *> *topNewsModels;
@property(nonatomic, strong) NSMutableArray <QYZYTopBlocksModel *> *newsModels;
@property (nonatomic, assign)BOOL ispost;
@property (nonatomic, strong)NSString *userid;
@end

@implementation QYZYPersonalhomepageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.ispost = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addConstraintsAndActions];
    [self loadData];

}

- (void)loadData {
    
    QYZYMIneApi *minApi = [QYZYMIneApi new];
    minApi.uid = (NSNumber *)self.authorId;
    [minApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYMineModel *model = [QYZYMineModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        self.userid = model.anchorId;
        [self.hadeView updataUI:model];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
    
    QYZYPostApi *postApi = [QYZYPostApi new];
    postApi.authorId =  self.authorId;
    postApi.pageNum = self.pageNum;
    postApi.pageSize = 15;
    [postApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *array = [NSArray yy_modelArrayWithClass:[QYZYCircleContentModel class] json:request.responseObject[@"data"][@"list"]];
        self.postArray = array;
        [self updataTableViewCell];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
    
    
    
    if (self.pageNum == 1) {
        [self.topNewsModels removeAllObjects];
        [self.newsModels removeAllObjects];
    }
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
- (void)addConstraintsAndActions
{
    
    self.pageNum = 1;
    
    if (self.postArray.count != 0) {
        self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.pageNum++;
            [self loadData];
        }];
    }

    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageNum = 1;
        [self loadData];
    }];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight);
    }];
}


#pragma mark - delegateMethod


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        if (self.ispost == YES) {
            if (self.postArray.count != 0) {
                return self.postArray.count;
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
    if (indexPath.section == 0) {
        
        QYZYPiecewiseTableViewCell *cell = [[QYZYPiecewiseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QYZYPiecewiseTableViewCell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell ispost:self.ispost];
        [cell setButtonBlock:^(UIButton * _Nonnull button) {
            if (button == cell.postButton) {
                NSLog(@"帖子");
                self.ispost = YES;
                //刷新单个section
            }
            else
            {
                NSLog(@"文章");
                self.ispost = NO;
            }
            
            [self updataTableViewCell];
        }];

        
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        if (self.ispost == YES) {
            if (self.postArray.count != 0) {
                QYZYCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYCircleCell" forIndexPath:indexPath];
                cell.model = self.postArray[indexPath.row];
                return cell;
            }
            else
            {
              
                QYZYNodataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYNodataTableViewCell" forIndexPath:indexPath];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                return cell;
            }
        }
        else
        {
            QYZYNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
            NSMutableArray *array = [NSMutableArray array];
            [array addObjectsFromArray:self.topNewsModels];
            [array addObjectsFromArray:self.newsModels];
            cell.model = array[indexPath.row];
            return cell;
        }
    }
   
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 58;
    }
    if (indexPath.section == 1) {
        if (self.ispost == YES) {
            if (self.postArray.count != 0) {
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
    
    if (indexPath.section == 1) {
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
            [self.navigationController pushViewController:vc animated:YES];
        }
       
    }
    
}


- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableHeaderView = self.hadeView;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableview registerClass:[QYZYPiecewiseTableViewCell class] forCellReuseIdentifier:@"QYZYPiecewiseTableViewCell"];
        [_tableview registerClass:[QYZYNodataTableViewCell class] forCellReuseIdentifier:@"QYZYNodataTableViewCell"];
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYNewsTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
        [_tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYCircleCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYCircleCell.class)];
        
        if (@available(iOS 11.0, *)) {
            _tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        
    }
    return _tableview;
}


- (void)focusClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"已关注"]) {
        //取消关注
        [self Canceltheattention];
    }
    else
    {
        //关注
        [self Focuson];
    }
}

- (void)upLiveClick
{
    QYZYLiveDetailViewController *vc = [[QYZYLiveDetailViewController alloc]init];
    vc.anchorId = self.userid;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (QYZYPersonalHadeView *)hadeView
{
    weakSelf(self);
    
    if (!_hadeView) {
        _hadeView = [[QYZYPersonalHadeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 216)];
        [_hadeView.focusButton addTarget:self action:@selector(focusClick:) forControlEvents:UIControlEventTouchUpInside];
        [_hadeView.livstudioButton addTarget:self action:@selector(upLiveClick) forControlEvents:UIControlEventTouchUpInside];
        [_hadeView setBackBlock:^{
            [weakself.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _hadeView;
}

//取消
- (void)Canceltheattention
{
    QYZYNewsPostAttentionCancelApi *api = [[QYZYNewsPostAttentionCancelApi alloc] init];
    api.userId = self.authorId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"已取消关注"];
        [self.hadeView updaFocus:NO];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {}];
}

//关注
- (void)Focuson
{
    QYZYNewsPostAttentionApi *api = [[QYZYNewsPostAttentionApi alloc] init];
    api.userId = self.authorId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"关注成功"];
        [self.hadeView updaFocus:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"");
    }];
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

- (NSArray *)postArray
{
    if (!_postArray) {
        _postArray = [[NSMutableArray alloc]init];
    }
    return _postArray;
}

- (void)updataTableViewCell
{
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableview reloadSections:indexSet withRowAnimation: UITableViewRowAnimationNone];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
