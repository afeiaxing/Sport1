//
//  QYZYSearchController.m
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "QYZYSearchController.h"

#import "QYZYSearchUtils.h"

#import "QYZYSearchCell.h"
#import "QYZYResultLiveRoomCell.h"
#import "QYZYEmptyCell.h"

#import "QYZYResultAnchorCell.h"
#import "QYZYSearchResultHeader.h"

#import "QYZYSearchApi.h"
#import "QYZYHotSearchApi.h"

#import "QYZYSearchAnchorModel.h"
#import "QYZYSearchLiveModel.h"

#import "QYZYLiveDetailViewController.h"

#define SearchHistoryKey @"SearchHistoryKey"

@interface QYZYSearchController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, strong) NSMutableArray <NSString *>*hotSearchKeys;

@property (nonatomic, strong) NSMutableArray <NSString *>*historyKeys;

@property (nonatomic, strong) NSMutableArray <QYZYSearchAnchorModel *>*anchors;

@property (nonatomic, strong) NSMutableArray *liveRooms;

@property (nonatomic, assign) BOOL isResult;

@end

@implementation QYZYSearchController

#pragma mark - lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = rgb(248, 249, 254);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[QYZYSearchCell class] forCellReuseIdentifier:@"QYZYSearchCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"QYZYResultAnchorCell" bundle:nil] forCellReuseIdentifier:@"QYZYResultAnchorCell"];
        [_tableView registerClass:[QYZYSearchResultHeader class] forHeaderFooterViewReuseIdentifier:@"QYZYSearchResultHeader"];
        [_tableView registerNib:[UINib nibWithNibName:@"QYZYResultLiveRoomCell" bundle:nil] forCellReuseIdentifier:@"QYZYResultLiveRoomCell"];
        [_tableView registerClass:[QYZYEmptyCell class] forCellReuseIdentifier:@"QYZYEmptyCell"];
    }
    return _tableView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.backgroundColor = UIColor.whiteColor;
        _searchTextField.layer.cornerRadius = 17;
        _searchTextField.placeholder = @"请输入主播或赛事";
        _searchTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        imgView.image = [UIImage imageNamed:@"news_search_icon"];
        [leftView addSubview:imgView];
        imgView.center = leftView.center;
        _searchTextField.leftView = leftView;
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _searchTextField;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

- (NSMutableArray *)hotSearchKeys {
    if (!_hotSearchKeys) {
        _hotSearchKeys = [[NSMutableArray alloc] init];
    }
    return _hotSearchKeys;
}

- (NSMutableArray<QYZYSearchAnchorModel *> *)anchors {
    if (!_anchors) {
        _anchors = [[NSMutableArray alloc] init];
    }
    return _anchors;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyKeys = [self readArchiverCachePath:SearchHistoryKey];
    [self configNavigation];
    [self setupController];
    [self loadData];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.searchTextField becomeFirstResponder];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)configNavigation {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [rightBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    self.rightItem = rightBtn;
}

- (void)setupController {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.searchTextField.frame = CGRectMake(0, 0, ScreenWidth, 32);
    self.navigationItem.titleView = self.searchTextField;
}

#pragma mark - action
- (void)searchAction:(id)sender {
    
    if (self.searchTextField.text.length==0) {
        return;
    }
    
    NSMutableArray *historyArr = [self readArchiverCachePath:SearchHistoryKey];
    if (!historyArr) {
        historyArr = [[NSMutableArray alloc] init];
    }
    
    if (![historyArr containsObject:self.searchTextField.text]) {
        [historyArr addObject:self.searchTextField.text];
        [self saveArchiverCacheRootObject:historyArr Path:SearchHistoryKey];
    }
    
    self.isResult = YES;
    [self getSearchResultDataWithKey:self.searchTextField.text];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - method
- (void)recorganizeData {
    [self.sections removeAllObjects];
    
    if (self.isResult) {
        if (self.anchors.count > 0) {
            [self.sections addObject:@(Result_anchor)];
        }
        
        if (self.liveRooms.count > 0) {
            [self.sections addObject:@(Result_live)];
        }
    }else {
        if (self.historyKeys.count > 0) {
            [self.sections addObject:@(SearchHistoryType)];
        }
        
        if (self.hotSearchKeys.count > 0) {
            [self.sections addObject:@(SearchHotType)];
        }
    }
    
    if (self.sections.count == 0) {
        [self.sections addObject:@(Empty)];
    }
    
    [self.tableView reloadData];
}

- (void)saveArchiverCacheRootObject:(id)rootObject Path:(NSString *)path {
    if (path.length == 0 || !rootObject) return;
    NSString * filePath = [self getArchiverCachePath:path];
    [NSKeyedArchiver archiveRootObject:rootObject toFile:filePath];
}

- (NSString *)getArchiverCachePath:(NSString *)path {
    return [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), path];
}

- (id)readArchiverCachePath:(NSString *)path {
    if (path.length == 0) return nil;
    NSString * filePath = [self getArchiverCachePath:path];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

- (void)removeArchiverCachePath:(NSString *)path {
    NSString * filePath = [self getArchiverCachePath:path];
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        [NSFileManager.defaultManager removeItemAtPath:filePath error:nil];
    }
}

#pragma mark - request
- (void)loadData {
    QYZYHotSearchApi *api = [QYZYHotSearchApi new];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        id data = [request.responseObject valueForKey:@"data"];
        if([data isKindOfClass:[NSArray class]]) {
            self.hotSearchKeys = data;
            [self recorganizeData];
        }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}

- (void)getSearchResultDataWithKey:(NSString *)keyword {
    QYZYSearchApi *api = [QYZYSearchApi new];
    api.keyword = keyword;
    api.searchType = 1;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view endEditing:YES];
        id data = [request.responseObject valueForKey:@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            id anchors = [data valueForKey:@"anchors"];
            if ([anchors isKindOfClass:[NSArray class]]) {
                NSArray <QYZYSearchAnchorModel *>*models = [NSArray yy_modelArrayWithClass:[QYZYSearchAnchorModel class] json:anchors];
                self.anchors = models.mutableCopy;
            }
            
            id liveRooms = [data valueForKey:@"liveRooms"];
            if ([liveRooms isKindOfClass:[NSArray class]]) {
                NSArray <QYZYSearchLiveModel *>*models = [NSArray yy_modelArrayWithClass:[QYZYSearchLiveModel class] json:liveRooms];
                __block NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
                [models enumerateObjectsUsingBlock:^(QYZYSearchLiveModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx%2==0) {
                        NSMutableArray *subArr = [[NSMutableArray alloc] init];
                        [subArr addObject:obj];
                        [tmpArr addObject:subArr];
                    }else {
                        NSMutableArray *subArr = tmpArr.lastObject;
                        [subArr addObject:obj];
                    }
                }];
                self.liveRooms = tmpArr;
            }
        }
        
        [self recorganizeData];
        
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sections.count > section) {
        SearchType type = [self.sections[section] integerValue];
        if (type == SearchHistoryType || type == SearchHotType) {
            return 1;
        }else if (type == Result_anchor) {
            return self.anchors.count;
        }else if (type == Empty) {
            return 1;
        }else {
            return self.liveRooms.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.sections.count > indexPath.section) {
        SearchType type = [self.sections[indexPath.section] integerValue];
        
        if (type == SearchHistoryType||type == SearchHotType) {
            QYZYSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYSearchCell" forIndexPath:indexPath];
            cell.searchKeys = type==SearchHistoryType?self.historyKeys:self.hotSearchKeys;
            cell.type = type;
            weakSelf(self)
            cell.clearClickBlock = ^{
                strongSelf(self)
                [self removeArchiverCachePath:SearchHistoryKey];
                self.historyKeys = @[].mutableCopy;
                [self recorganizeData];
                [self.tableView reloadData];
            };
            
            cell.searchKeyBlock = ^(NSString * _Nonnull searchKey) {
              strongSelf(self)
                self.searchTextField.text = searchKey;
                [self searchAction:nil];
            };
            return cell;
        }else if (type == Empty) {
            QYZYEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYEmptyCell" forIndexPath:indexPath];
            cell.type = EmptyTypeNoResult;
            return cell;
        }else {
            if (type == Result_anchor) {
                QYZYResultAnchorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYResultAnchorCell" forIndexPath:indexPath];
                cell.model = self.anchors[indexPath.row];
                return cell;
            }else {
                QYZYResultLiveRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYResultLiveRoomCell" forIndexPath:indexPath];
                cell.models = self.liveRooms[indexPath.row];
                weakSelf(self)
                cell.block = ^(NSString * _Nonnull anchorId) {
                    strongSelf(self)
                    !self.goToLivePageBlock?:self.goToLivePageBlock(anchorId);
                };
                return cell;
            }
        }
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SearchType type = [self.sections[section] integerValue];
    if (type == SearchHistoryType || type == SearchHotType) {
        return 0.1;
    }
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.sections.count > section) {
        SearchType type = [self.sections[section] integerValue];
        
        if (type == Result_live||type == Result_anchor) {
            QYZYSearchResultHeader *header = [[QYZYSearchResultHeader alloc] initWithReuseIdentifier:@"QYZYSearchResultHeader"];
            header.title = type == Result_anchor?@"相关主播":@"相关直播";
            return header;
        }
    }

    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchType type = [self.sections[indexPath.section] integerValue];
    if (type == Result_anchor) {
        if (self.anchors.count > indexPath.row) {
            QYZYSearchAnchorModel *model = self.anchors[indexPath.row];
            !self.goToLivePageBlock?:self.goToLivePageBlock(model.anchorId);
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
