//
//  QYZYNewsDetailViewController.m
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import <WebKit/WebKit.h>
#import "QYZYNewsDetailViewController.h"
#import "QYZYPersonalhomepageViewController.h"
#import "QYZYNewsDetailHeadSectionView.h"
#import "QYZYNewsTableViewCell.h"
#import "QYZYCommendListCell.h"
#import "QYZYEmptyCell.h"
#import "QYZYCommendNewsView.h"
#import "QYZYCommendInputView.h"
#import "QYZYReportView.h"

#import "QYZYNewsDetailApi.h"
#import "QYZYNewsPostAttentionApi.h"
#import "QYZYNewsPostAttentionCancelApi.h"
#import "QYZYNewsCommentsApi.h"
#import "QYZYNewsCommentInspectionApi.h"
#import "QYZYNewsSaveCommentApi.h"
#import "QYZYMsgInspectionApi.h"
#import "QYZYNewsLikeApi.h"
#import "QYZYNewsFavoritesApi.h"
#import "QYZYNewsFavoritesRemoveApi.h"
#import "QYZYReportApi.h"
#import "QYZYReportContentApi.h"


#import "QYZYNewsDetailModel.h"
#import "QYZYNewsDetailNewsModel.h"
#import "QYZYNewsDetailCurrentNewsModel.h"
#import "QYZYNewsCommentModel.h"
#import "QYZYReportModel.h"




@interface QYZYNewsDetailViewController ()<UITableViewDelegate, UITableViewDataSource,WKUIDelegate,WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPublishTime;
@property (weak, nonatomic) IBOutlet UIButton *userIsFollow;
@property (weak, nonatomic) IBOutlet WKWebView *webview;

@property(nonatomic, assign) NSUInteger pageNum;

@property (nonatomic, strong) QYZYNewsDetailNewsModel *newsModel;
@property (nonatomic, strong) NSArray *currentNews;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *reportArray;
@property (nonatomic, strong) NSMutableArray *reportTitles;
@property (nonatomic, strong) QYZYCommendInputView *commendInputView;
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat webViewHeight;

@end

@implementation QYZYNewsDetailViewController

- (void)dealloc {
    if (self.webview.scrollView) [self.webview.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [self.webview removeFromSuperview];
    self.webview = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)isattentionAnction:(id)sender {
    if (QYZYUserManager.shareInstance.isLogin == false) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [self presentViewController:vc animated:true completion:nil];
        });
        return;
    }
    
    self.newsModel.isAttention ? [self loadAttentionCancel] : [self loadAttention];
    
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

- (void)share {
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];

    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];

    UIImage *image = [UIImage imageNamed:icon];
 
    NSString *shareText = self.newsModel.title;
    UIImage *shareImage = image;
    NSString *shareStr = @"";
    NSURL *shareURL = [NSURL URLWithString:shareStr];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"completionHandler:nil];
}

- (void)resetWebViewFrameWithHeight:(CGFloat)newHeight {
    
    if (ABS(newHeight - self.webViewHeight) > 10) {
        CGRect webFrame = self.webview.frame;
        webFrame.size.height = newHeight + 6;
        self.webViewHeight = newHeight + 6;
        self.webview.frame = webFrame;
        CGRect frame = self.headerView.frame;
        frame.size.height = webFrame.size.height + 146;
        self.headerViewHeight = frame.size.height;
        self.headerView.frame = frame;
        [self.tableview reloadData];
    }

    [UIView animateWithDuration:0.35 animations:^{
        self.webview.alpha = 1;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    
    [self initUI];
    [self initTableView];
    [self configNavigation];
    [self reportContentRequest];
    [self loadDetail];
    [self addObserver];
    
    //WKWebView
    [self.webview.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

//监听高度变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    CGFloat newHeight = self.webview.scrollView.contentSize.height;;
    [self resetWebViewFrameWithHeight:newHeight];
}

- (void)configNavigation {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn setImage:[UIImage imageNamed:@"circle_more"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightItem = rightBtn;
}

- (void)initUI {
    self.userIsFollow.layer.masksToBounds = YES;
    self.userIsFollow.layer.cornerRadius = 12;
    self.userIsFollow.layer.borderWidth = 1;
    self.userIsFollow.layer.borderColor = rgb(149, 157, 176).CGColor;
    
    self.userIcon.layer.cornerRadius = 16;
    self.userIcon.layer.masksToBounds = YES;
    self.userIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterUserHomePage)];
    [self.userIcon addGestureRecognizer:tap];
    self.webview.scrollView.scrollEnabled = NO;
    self.webview.UIDelegate = self;
    self.webview.navigationDelegate = self;
}

- (void)initTableView {
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 52 + self.view.safeAreaInsets.bottom)];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYNewsTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYCommendListCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYCommendListCell.class)];
    [self.tableview registerClass:QYZYEmptyCell.class forCellReuseIdentifier:NSStringFromClass(QYZYEmptyCell.class)];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYNewsDetailHeadSectionView.class) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass(QYZYNewsDetailHeadSectionView.class)];
    
    weakSelf(self)
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        strongSelf(self)
        self.pageNum ++;
        [self loadDetail];
    }];
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self)
        self.pageNum = 1;
        [self loadDetail];
    }];
    
    [self.view addSubview:self.commendInputView];
    [self.commendInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
        make.width.mas_offset(ScreenWidth);
        make.height.mas_offset(52 + [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom);
    }];
}

- (void)enterUserHomePage {
    if (self.newsModel.userId) {
        QYZYPersonalhomepageViewController *personalVc = [[QYZYPersonalhomepageViewController alloc] init];
        personalVc.authorId = self.newsModel.userId;
        personalVc.hidesBottomBarWhenPushed = YES;
        [UIViewController.currentViewController.navigationController pushViewController:personalVc animated:YES];
    }
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

- (void)handleUserInfo {
    self.title = self.newsModel.title;
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:self.newsModel.headImgUrl] placeholderImage:QYZY_DEFAULT_AVATAR];
    self.userTitle.text = self.newsModel.title;
    self.userName.text = self.newsModel.nickName;
    self.userPublishTime.text = self.newsModel.createdDate;
    [self.userIsFollow setTitle:self.newsModel.isAttention ? @"已关注" : @"关注" forState:UIControlStateNormal];
    [self.webview loadHTMLString:self.newsModel.content baseURL:nil];
    
    [self.sections replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"全部评论(%@)",self.newsModel.commentCount]];
    
    self.commendInputView.isLike = self.newsModel.isLike;
    self.commendInputView.isFavorites = self.newsModel.isFavorites;
    self.commendInputView.commentCount = self.newsModel.commentCount;
}


#pragma mark - Net
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
    api.reportBy = self.newsModel.ID;
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"举报成功!我们将尽快处理!"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [UIView qyzy_showMsg:@"举报成功!我们将尽快处理!"];
    }];
}

- (void)loadDetail {
    QYZYNewsDetailApi *api = [QYZYNewsDetailApi new];
    api.ID = self.newsId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        QYZYNewsDetailModel *model = [QYZYNewsDetailModel yy_modelWithJSON:[request.responseObject valueForKey:@"data"]];
        self.newsModel = model.news;
        self.currentNews = model.currentNews;
        [self handleUserInfo];
        [self loadComments];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {

    }];
}

- (void)loadAttention {
    QYZYNewsPostAttentionApi *api = [[QYZYNewsPostAttentionApi alloc] init];
    api.userId = self.newsModel.userId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self.view qyzy_showMsg:@"关注成功"];
        [self.userIsFollow setTitle:@"已关注" forState:UIControlStateNormal];
        [self loadDetail];
        [self.tableview reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:@"关注失败"];
    }];
}

- (void)loadAttentionCancel {
    QYZYNewsPostAttentionCancelApi *api = [[QYZYNewsPostAttentionCancelApi alloc] init];
    api.userId = self.newsModel.userId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self.view qyzy_showMsg:@"取消关注"];
        [self.userIsFollow setTitle:@"关注" forState:UIControlStateNormal];
        [self loadDetail];
        [self.tableview reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:@"取消关注失败"];
    }];
}

- (void)loadComments {
    if (self.pageNum == 1) {
        [self.comments removeAllObjects];
    }
    QYZYNewsCommentsApi *api = [[QYZYNewsCommentsApi alloc] init];
    api.pageNum = self.pageNum;
    api.pageSize = 15;
    api.newsId = self.newsId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        NSArray *models = [NSArray yy_modelArrayWithClass:QYZYNewsCommentModel.class json:[[request.responseObject valueForKey:@"data"] valueForKey:@"list"]];
        
        if ([self.tableview.mj_header isRefreshing]) {
            [self.tableview.mj_header endRefreshing];
            self.comments = models.mutableCopy;
        }else {
            [self.tableview.mj_footer endRefreshing];
            [self.comments addObjectsFromArray:models.mutableCopy];
        }
        if (models.count < 15) {
            self.tableview.mj_footer.hidden = YES;
        }else {
            self.tableview.mj_footer.hidden = NO;
        }
        [self.tableview reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
    }];
}

- (void)loadSaveComment:(NSString *)msg {
    QYZYNewsSaveCommentApi *api = [QYZYNewsSaveCommentApi new];
    api.content = msg;
    api.newsId = self.newsId;
    [self.view qyzy_showMsg:@"发布中!"];
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self.view qyzy_showMsg:@"发布成功"];
        self.pageNum = 1;
        [self loadComments];
        self.commendInputView.textView.text = @"";
        [self.view endEditing:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
}

- (void)textInspection:(NSString *)msg {
    QYZYNewsCommentInspectionApi *api = [QYZYNewsCommentInspectionApi new];
    api.text = msg;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id subData = [data valueForKey:@"data"];
            if ([subData isKindOfClass:[NSString class]]) {
                NSString *str = subData;
                if (str.length == 0) {
                    [self loadSaveComment:msg];
                }else {
                    [self.view qyzy_showMsg:str];
                }
            }else {
                if (subData == nil ||subData == [NSNull null]) {
                    [self loadSaveComment:msg];
                }
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
}

- (void)likeRequest {
    QYZYNewsLikeApi *api = [QYZYNewsLikeApi new];
    api.ID = self.newsId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self.view qyzy_showMsg:@"点赞成功"];
        self.commendInputView.isLike = YES;
        [self loadDetail];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
}

- (void)collectRequest {
    QYZYNewsFavoritesApi *api = [QYZYNewsFavoritesApi new];
    api.ID = self.newsId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self.view qyzy_showMsg:@"收藏成功"];
        self.commendInputView.isFavorites = YES;
        [self loadDetail];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
}

- (void)cancelCollectRequest {
    QYZYNewsFavoritesRemoveApi *api = [QYZYNewsFavoritesRemoveApi new];
    api.ID = self.newsId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        [self.view qyzy_showMsg:@"取消收藏成功"];
        self.commendInputView.isFavorites = NO;
        [self loadDetail];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view qyzy_showMsg:request.error.localizedDescription];
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.currentNews.count;
    }
    return self.comments.count ? : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            QYZYNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYNewsTableViewCell.class)];
            cell.model = self.currentNews[indexPath.row];
            return cell;
        }
            break;
        case 1:
        {
            if (self.comments.count == 0) {
                QYZYEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYEmptyCell.class)];
                cell.type = EmptyTypeNoData;
                return cell;
            }
            QYZYCommendListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYCommendListCell.class)];
        
            cell.newsCommentModel = self.comments[indexPath.row];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return nil;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QYZYNewsDetailViewController *vc = [[QYZYNewsDetailViewController alloc] initWithNibName:NSStringFromClass(QYZYNewsDetailViewController.class) bundle:nil];
        QYZYNewsDetailCurrentNewsModel *model = self.currentNews[indexPath.row];
        vc.newsId = model.newsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.section == 1) {
        if (self.comments.count > indexPath.row) {
            QYZYNewsCommentModel *model = self.comments[indexPath.row];
            QYZYCommendNewsView *view = [[QYZYCommendNewsView alloc] initWithBottomArea:self.view.safeAreaInsets.bottom commentId:model.ID newsId:model.newsId];
            [view showView];
        }
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QYZYNewsDetailHeadSectionView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(QYZYNewsDetailHeadSectionView.class)];
    header.titleLab.text = self.sections[section];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 106;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - Get
- (QYZYNewsDetailNewsModel *)newsModel {
    if (!_newsModel) {
        _newsModel = [[QYZYNewsDetailNewsModel alloc] init];
    }
    return _newsModel;
}

- (NSArray *)currentNews {
    if (!_currentNews) {
        _currentNews = [NSArray array];
    }
    return _currentNews;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = @[@"相关推荐",@"全部评论（0）"].mutableCopy;
    }
    return _sections;
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}

- (QYZYCommendInputView *)commendInputView {
    if (!_commendInputView) {
        _commendInputView = [[QYZYCommendInputView alloc] init];
        _commendInputView.backgroundColor = UIColor.whiteColor;
        _commendInputView.parentView = self.view;
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
            if (self.newsModel.isFavorites == NO) {
                [self collectRequest];
            }else {
                [self cancelCollectRequest];
            }
        };
        
        _commendInputView.shareClickBlock = ^{
            strongSelf(self)
            [self share];
        };
    }
    return _commendInputView;
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

@end
