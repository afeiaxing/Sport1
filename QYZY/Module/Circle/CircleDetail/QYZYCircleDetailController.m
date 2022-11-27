//
//  QYZYCircleDetailController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleDetailController.h"
#import "QYZYCircleDetailApi.h"
#import "QYZYCircleDetailHeader.h"

#import "QYZYCircleCommendModel.h"
#import "QYZYCircleContentModel.h"

#import "QYZYCommendListCell.h"
#import "QYZYCircleDetailCell.h"
#import "QYZYEmptyCell.h"

#import "QYZYCommendInputView.h"
#import "IQKeyboardManager.h"

#import "QYZYMsgInspectionApi.h"
#import "QYZYCommendSendApi.h"

#import "QYZYCommendController.h"
#import "QYZYCommendView.h"

#import "QYZYNewsPostAttentionApi.h"
#import "QYZYNewsPostAttentionCancelApi.h"
#import "QYZYLikeApi.h"

#import "QYZYCollectApi.h"
#import "QYZYCancelCollectApi.h"
#import "QYZYReportContentApi.h"

#import "QYZYPhoneLoginViewController.h"

#import "QYZYReportView.h"
#import "QYZYReportModel.h"

#import "QYZYReportApi.h"
#import "QYZYReportModel.h"

typedef NS_ENUM(NSUInteger, CircleCellType) {
    CircleCellDetailType,
    CircleCellReplyType
};

@interface QYZYCircleDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, strong) NSMutableArray *commendList;

@property (nonatomic, strong) QYZYCommendInputView *commendInputView;

@property (nonatomic, strong) NSMutableArray *reportArray;

@property (nonatomic, strong) NSMutableArray *reportTitles;

@end

@implementation QYZYCircleDetailController

- (void)dealloc {
    NSLog(@"dealloc");
}

#pragma mark - lazy load
- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

- (NSMutableArray *)commendList {
    if (!_commendList) {
        _commendList = [[NSMutableArray alloc] init];
    }
    return _commendList;
}

- (NSMutableArray *)reportArray {
    if (!_reportArray) {
        _reportArray = [[NSMutableArray alloc] init];
    }
    return _reportArray;
}

- (NSMutableArray *)reportTitles {
    if (!_reportTitles) {
        _reportTitles = [[NSMutableArray alloc] init];
    }
    return _reportTitles;
}

- (QYZYCommendInputView *)commendInputView {
    if (!_commendInputView) {
        _commendInputView = [[QYZYCommendInputView alloc] init];
        _commendInputView.backgroundColor = UIColor.whiteColor;
        _commendInputView.parentView = self.view;
        _commendInputView.isLike = self.model.isLike;
        _commendInputView.isFavorites = self.model.isFavorites;
        weakSelf(self)
        _commendInputView.msgSendBlock = ^(NSString * _Nonnull msg) {
            strongSelf(self)
            [self textInspection:msg];
        };
        _commendInputView.likeClickBlock = ^{
          strongSelf(self)
            [self likeRequest];
        };
        _commendInputView.collectClickBlock = ^{
          strongSelf(self)
            if (self.model.isFavorites == NO) {
                [self collectRequest];
            }else {
                [self cancelCollectRequest];
            }
        };
        _commendInputView.shareClickBlock = ^{
            strongSelf(self)
            [self showShareView:self.model];
        };
        
    }
    return _commendInputView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self configNavigation];
    [self configDatas];
    [self reportContentRequest];
    [self loadData];
    [self addObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QYZYCircleDetailCell" bundle:nil] forCellReuseIdentifier:@"QYZYCircleDetailCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"QYZYCommendListCell" bundle:nil] forCellReuseIdentifier:@"QYZYCommendListCell"];
    [self.tableView registerClass:[QYZYCircleDetailHeader class] forHeaderFooterViewReuseIdentifier:@"QYZYCircleDetailHeader"];
    [self.tableView registerClass:[QYZYEmptyCell class] forCellReuseIdentifier:@"QYZYEmptyCell"];
    
    self.tableView.backgroundColor = rgb(248, 250, 255);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 52 + self.view.safeAreaInsets.bottom)];
    
    [self.view addSubview:self.commendInputView];
    [self.commendInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.width.mas_offset(ScreenWidth);
        make.height.mas_offset(52 + self.view.safeAreaInsets.bottom);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)configNavigation {
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setImage:[UIImage imageNamed:@"circle_more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    self.rightItem = rightBtn;
}

- (void)configDatas {
    [self.sections addObject:@(CircleCellDetailType)];
    [self.sections addObject:@(CircleCellReplyType)];
}

- (void)loadData {
    QYZYCircleDetailApi *api = [QYZYCircleDetailApi new];
    api.postId = self.model.Id;
    api.pageNum = 1;
    api.pageSize = 15;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            strongSelf(self)
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id subData = [data valueForKey:@"data"];
            if ([subData isKindOfClass:[NSDictionary class]]) {
                id parent = [subData valueForKey:@"parent"];
                if ([parent isKindOfClass:[NSDictionary class]]) {
                    QYZYCircleContentModel *model = [QYZYCircleContentModel yy_modelWithJSON:parent];
                    if (!model.postImgLists) {
                        model.postImgLists = self.model.postImgLists;
                    }
                    self.model = model;
                }
                
                id son = [subData valueForKey:@"son"];
                if ([son isKindOfClass:[NSDictionary class]]) {
                    id list = [son valueForKey:@"list"];
                    NSArray *models = [NSArray yy_modelArrayWithClass:[QYZYCircleCommendModel class] json:list];
                    self.commendList = models.mutableCopy;
                }
                
                [self.tableView reloadData];
            }
        }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [UIView qyzy_showMsg:request.error.localizedDescription];
        }];
}

- (void)textInspection:(NSString *)msg {
    QYZYMsgInspectionApi *api = [QYZYMsgInspectionApi new];
    api.text = msg;
    [self.view qyzy_showMsg:@"发布中!"];
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            strongSelf(self)
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id subData = [data valueForKey:@"data"];
            if ([subData isKindOfClass:[NSString class]]) {
                NSString *str = subData;
                if (str.length == 0) {
                    [self commendPost:msg];
                }else {
                    [self.view qyzy_showMsg:str];
                }
            }else {
                if (subData == nil ||subData == [NSNull null]) {
                    [self commendPost:msg];
                }
            }
        }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        }];
}

- (void)commendPost:(NSString *)content {
    QYZYCommendSendApi *api = [QYZYCommendSendApi new];
    api.isComment = @"1";
    api.content = content;
    api.replyId = self.model.Id;
    
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self.view endEditing:YES];
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view qyzy_showMsg:@"发布成功"];
        });
        [self loadData];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view qyzy_showMsg:@"发布失败"];
            });
        }];
}

- (void)loadAttentionWithModel:(QYZYCircleContentModel *)model {
    QYZYNewsPostAttentionApi *api = [[QYZYNewsPostAttentionApi alloc] init];
    api.userId = model.userId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"关注成功"];
        self.model.isAttention = true;
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:request.error.localizedDescription];
    }];
}

- (void)loadAttentionCancelWithModel:(QYZYCircleContentModel *)model {
    QYZYNewsPostAttentionCancelApi *api = [[QYZYNewsPostAttentionCancelApi alloc] init];
    api.userId = model.userId;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"已取消关注"];
        self.model.isAttention = false;
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:request.error.localizedDescription];
    }];
}

- (void)likeRequest {
    QYZYLikeApi *api = [[QYZYLikeApi alloc] init];
    api.Id = self.model.Id;
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (self.model.isLike) {
            // 没有取消点赞，后台一分钟缓存
            return;
        }
        self.model.isLike = !self.model.isLike;
        self.commendInputView.isLike = self.model.isLike;
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        }];
}

- (void)collectRequest {
    QYZYCollectApi *api = [QYZYCollectApi new];
    api.Id = self.model.Id;
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.model.isFavorites = YES;
        self.commendInputView.isFavorites = YES;
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        }];
}

- (void)cancelCollectRequest {
    QYZYCancelCollectApi *api = [QYZYCancelCollectApi new];
    api.Id = self.model.Id;
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        self.model.isFavorites = NO;
        self.commendInputView.isFavorites = NO;
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        }];
}

- (void)reportContentRequest {
    QYZYReportContentApi *api = [QYZYReportContentApi new];
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            strongSelf(self)
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id array = [data valueForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                NSArray *models = [NSArray yy_modelArrayWithClass:[QYZYReportModel class] json:array];
                self.reportArray = models.mutableCopy;
                
                __block NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
                [models enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    QYZYReportModel *model = obj;
                    [tmpArray addObject:model.reason];
                }];
                
                [self.reportTitles addObject:tmpArray];
                [self.reportTitles addObject:@[@"取消"]];
            }
        }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        }];
}

- (void)reportRequestAtIndex:(NSInteger)index {
    
    QYZYReportModel *model = self.reportArray[index];
    
    QYZYReportApi *api = [QYZYReportApi new];
    api.reason = model.reason;
    api.idType = model.reportType;
    api.reasonId = model.reasonId;
    api.reportBy = self.model.Id;
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"举报成功!我们将尽快处理!"];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [UIView qyzy_showMsg:@"举报成功!我们将尽快处理!"];
        }];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notify {
    CGFloat keyboardHeight = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self.commendInputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyboardHeight);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.commendInputView updateInputViewWithStatus:YES];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notify {
    CGFloat duration = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [self.commendInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.width.mas_offset(ScreenWidth);
        make.height.mas_offset(52 + self.view.safeAreaInsets.bottom);
    }];
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.commendInputView updateInputViewWithStatus:NO];
    }];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)more {
    QYZYReportView *reportView = [[QYZYReportView alloc] initWithSafeArea:self.view.safeAreaInsets.bottom];
    reportView.dataArray = self.reportTitles;
    [reportView showView];
    weakSelf(self)
    reportView.actionBlock = ^(NSInteger selectIndex) {
        strongSelf(self)
        if (!QYZYUserManager.shareInstance.isLogin) {
            QYZYPhoneLoginViewController *loginVc = [QYZYPhoneLoginViewController new];
            [self.navigationController presentViewController:loginVc animated:YES completion:nil];
            return;
        }
        
        [self reportRequestAtIndex:selectIndex];
    };
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sections.count > section) {
        CircleCellType type = [self.sections[section] integerValue];
        if (type == CircleCellReplyType) {
            NSInteger rows = self.commendList.count == 0 ? 1:self.commendList.count;
            return rows;
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.sections.count > indexPath.section) {
        CircleCellType type = [self.sections[indexPath.section] integerValue];

        if (type == CircleCellDetailType) {
            QYZYCircleDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYCircleDetailCell" forIndexPath:indexPath];
            cell.backgroundColor = UIColor.whiteColor;
            cell.model = self.model;
            
            weakSelf(self)
            cell.followBlock = ^(QYZYCircleContentModel * _Nonnull model) {
                strongSelf(self)
                if (!QYZYUserManager.shareInstance.isLogin) {
                    QYZYPhoneLoginViewController *loginVc = [QYZYPhoneLoginViewController new];
                    [self.navigationController presentViewController:loginVc animated:YES completion:nil];
                    return;
                }
                
                if (model.isAttention == false) {
                    [self loadAttentionWithModel:model];
                }else {
                    [self loadAttentionCancelWithModel:model];
                }
            };
            return cell;
        }else {
            if (self.commendList.count==0) {
                QYZYEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYEmptyCell" forIndexPath:indexPath];
                cell.type = EmptyTypeNoData;
                return cell;
            }
            QYZYCommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYCommendListCell" forIndexPath:indexPath];
            cell.model = self.commendList[indexPath.row];
            return cell;
        }
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    QYZYCircleDetailHeader *header = [[QYZYCircleDetailHeader alloc] initWithReuseIdentifier:@"QYZYCircleDetailHeader"];
    if (self.sections.count > section) {
        CircleCellType type = [self.sections[section] integerValue];
        if (type == CircleCellReplyType) {
            header.title = [NSString stringWithFormat:@"全部评论 %@",self.model.sonNum];
        }
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.sections.count > section) {
        CircleCellType type = [self.sections[section] integerValue];
        if (type == CircleCellReplyType) {
            return 52;
        }
    }
    
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.sections.count > indexPath.section) {
        CircleCellType type = [self.sections[indexPath.section] integerValue];
        if (type == CircleCellReplyType) {
            if (self.commendList.count > indexPath.row) {
                QYZYCircleCommendModel *model = self.commendList[indexPath.row];
                
                QYZYCommendView *view = [[QYZYCommendView alloc] initWithBottomArea:self.view.safeAreaInsets.bottom model:model];
                [view showView];
            }
        }
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
