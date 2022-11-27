//
//  QYZYHotViewController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYHotViewController.h"
#import "QYZYCircleCell.h"
#import "QYZYHotHeadView.h"

#import "QYZYCircleListApi.h"
#import "QYZYCircleHotListApi.h"

#import "QYZYCircleListModel.h"
#import "QYZYCircleContentModel.h"

#import "QYZYEmptyCell.h"
#import "QYZYPersonalhomepageViewController.h"

@interface QYZYHotViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) QYZYHotHeadView *headView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation QYZYHotViewController
- (void)reloadData {
    [self.tableView reloadData];
}
#pragma mark - lazy load
- (QYZYHotHeadView *)headView {
    if (!_headView) {
        _headView = [[QYZYHotHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 96 + 24)];
        weakSelf(self)
        _headView.tapCircleBlock = ^(QYZYCircleListModel * _Nonnull model) {
            strongSelf(self)
            !self.circleTapBlock?:self.circleTapBlock(model);
        };
    }
    return _headView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCircleList];
    [self loadDataAtPage:1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:QYZYNetworkingFirstAvaliableNotification object:nil];
}

- (void)loadData {
    [self getCircleList];
    [self loadDataAtPage:1];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {

}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tableView registerNib:[UINib nibWithNibName:@"QYZYCircleCell" bundle:nil] forCellReuseIdentifier:@"QYZYCircleCell"];
    [self.tableView registerClass:[QYZYEmptyCell class] forCellReuseIdentifier:@"QYZYEmptyCell"];
//    self.tableView.tableHeaderView = self.headView;
    
    weakSelf(self)
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        strongSelf(self)
        NSInteger page = self.datas.count/15 + 1;
        [self loadDataAtPage:page];
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self)
        [self loadDataAtPage:1];
    }];
    
    self.tableView.mj_footer.hidden = YES;
    [self.view layoutIfNeeded];
}

#pragma mark - request
- (void)getCircleList {
    QYZYCircleListApi *api = [QYZYCircleListApi new];
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id array = [data valueForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                NSArray *models = [NSArray yy_modelArrayWithClass:[QYZYCircleListModel class] json:array];
                self.headView.datas = models.mutableCopy;
            }
        }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}

- (void)loadDataAtPage:(NSInteger)page {
    QYZYCircleHotListApi *api = [QYZYCircleHotListApi new];
    api.pageNum = page;
    api.pageSize = 15;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id subData = [data valueForKey:@"data"];
            if ([subData isKindOfClass:[NSDictionary class]]) {
                id array = [subData valueForKey:@"list"];
                if ([array isKindOfClass:[NSArray class]]) {
                    
                    NSArray *models = [NSArray yy_modelArrayWithClass:[QYZYCircleContentModel class] json:array];
                    
                    if ([self.tableView.mj_header isRefreshing]) {
                        [self.tableView.mj_header endRefreshing];
                        self.datas = models.mutableCopy;
                    }else {
                        [self.tableView.mj_footer endRefreshing];
                        [self.datas addObjectsFromArray:models.mutableCopy];
                    }
                    
                    if (models.count < 15) {
                        self.tableView.mj_footer.hidden = YES;
                    }else {
                        self.tableView.mj_footer.hidden = NO;
                    }
                }else {
                    [self.tableView.mj_header endRefreshing];
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        }else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self handleData];
        [self.tableView reloadData];

        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self handleData];
            [self.tableView reloadData];
        }];
}

- (void)handleData {
    
    [self.sections removeAllObjects];
    
    if (self.datas.count > 0) {
        [self.sections addObject:@(0)];
    }else {
        [self.sections addObject:@(1)];
    }
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sections.count > indexPath.section) {
        NSInteger type = [self.sections[indexPath.section] integerValue];
        if (type == 0) {
            QYZYCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYCircleCell" forIndexPath:indexPath];
            if (self.datas.count > indexPath.row) {
                cell.model = self.datas[indexPath.row];
            }
        
            weakSelf(self)
            cell.avatarTapBlock = ^(NSString * _Nonnull userId) {
                strongSelf(self)
                !self.personBlock?:self.personBlock(userId);
            };
            cell.shareTapBlock = ^(QYZYCircleContentModel * _Nonnull model) {
                strongSelf(self)
                if (!QYZYUserManager.shareInstance.isLogin) {
                    QYZYPhoneLoginViewController *vc = [[QYZYPhoneLoginViewController alloc] init];
                    [self.navigationController presentViewController:vc animated:YES completion:nil];
                    return;
                }
                
                [self showShareView:model];
            };
            cell.likeTapBlock = ^(QYZYCircleContentModel * _Nonnull model) {
              strongSelf(self)
                !self.likeBlock?:self.likeBlock(model);
            };
            
            return cell;
        }else {
            QYZYEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYEmptyCell" forIndexPath:indexPath];
            cell.type = EmptyTypeNoData;
            return cell;
        }
    }else {
        return [UITableViewCell new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.datas.count > indexPath.row) {
        QYZYCircleContentModel *model = self.datas[indexPath.row];
        !self.goToDetailPageBlock?:self.goToDetailPageBlock(model);
    }
}

- (void)showShareView:(QYZYCircleContentModel *)model {
    NSString *link = model.webShareUrl;
        NSString *shareText = model.content;
        UIImage *shareImage = [UIImage imageNamed:@"ES_InfoIndex_share_logo"];
        NSURL *shareURL = [NSURL URLWithString:link];
        NSArray *activityItems = [[NSArray alloc] initWithObjects:shareText, shareImage, shareURL, nil];
        
        UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(UIActivityType activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            if (completed) {
            } else {
            }
            [vc dismissViewControllerAnimated:YES completion:nil];
        };
        vc.completionWithItemsHandler = myBlock;
        [self presentViewController:vc animated:YES completion:nil];
}

@end
