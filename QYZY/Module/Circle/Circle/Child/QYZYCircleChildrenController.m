//
//  QYZYCircleChildrenController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleChildrenController.h"
#import "QYZYCircleCell.h"
#import "QYZYEmptyCell.h"

#import "QYZYCircleAllListApi.h"

#import "QYZYCircleContentModel.h"

@interface QYZYCircleChildrenController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) QYZYCircleListModel *model;

@property (nonatomic, strong) NSMutableArray *sections;

@end

@implementation QYZYCircleChildrenController

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark - lazy load
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
   
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.datas.count == 0) {
        [self loadDataAtPage:1];
    }
}

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    
}

- (instancetype)initWithModel:(QYZYCircleListModel *)model {
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.tableView registerNib:[UINib nibWithNibName:@"QYZYCircleCell" bundle:nil] forCellReuseIdentifier:@"QYZYCircleCell"];
    [self.tableView registerClass:[QYZYEmptyCell class] forCellReuseIdentifier:@"QYZYEmptyCell"];

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
            cell.model = self.datas[indexPath.row];
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
    }
    
    return [UITableViewCell new];

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

#pragma mark - request
- (void)loadDataAtPage:(NSInteger)page {
    QYZYCircleAllListApi *api = [QYZYCircleAllListApi new];
    api.pageNum = page;
    api.pageSize = 15;
    api.recommendStatus = @"0";
    api.circleId = self.model.Id;
    api.sort = @"1";
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            strongSelf(self)
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id subData = [data valueForKey:@"data"];
            if ([subData isKindOfClass:[NSDictionary class]]) {
                id array = [subData valueForKey:@"list"];
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
