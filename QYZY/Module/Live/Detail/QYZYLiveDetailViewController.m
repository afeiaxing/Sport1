//
//  QYZYLiveDetailViewController.m
//  QYZY
//
//  Created by jspollo on 2022/9/30.
//

#import "QYZYLiveDetailViewController.h"
#import "QYZYLiveDetailViewModel.h"
#import "QYZYLiveDetailModel.h"
#import "ZFIJKPlayerManager.h"
#import <WebKit/WebKit.h>
#import "QYZYBlockManager.h"
#import "QYZYNewsPostAttentionApi.h"
#import "QYZYNewsPostAttentionCancelApi.h"

#import "QYZYLiveMoreViewController.h"
#import "QYZYLiveRankViewController.h"
#import "QYZYLiveChatViewController.h"
#import "QYZYLiveAnchorViewController.h"
#import "QYZYPersonalhomepageViewController.h"

@interface QYZYLiveDetailViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic ,strong) UIView *statusView;
@property (nonatomic ,strong) QYZYLiveDetailViewModel *viewModel;
@property (nonatomic ,strong) QYZYLiveDetailModel *detailModel;
@property (nonatomic ,strong) UIButton *backButton;
@property (nonatomic ,strong) ZFPlayerController *player;
@property (nonatomic ,strong) ZFPlayerControlView *controlView;
@property (nonatomic ,strong) ZFIJKPlayerManager *playerManager;
@property (nonatomic ,strong) UIImageView *playerView;
@property (nonatomic ,strong) JXCategoryTitleView *categoryView;
@property (nonatomic ,strong) JXCategoryListContainerView *containerView;
@property (nonatomic ,strong) QYZYLiveMoreViewController *moreVC;
@property (nonatomic ,strong) QYZYLiveRankViewController *rankVC;
@property (nonatomic ,strong) QYZYLiveChatViewController *chatVC;
@property (nonatomic ,strong) QYZYLiveAnchorViewController *anchorVC;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) WKWebView *webView;
@property (nonatomic ,strong) UIControl *focusControl;
@property (nonatomic ,strong) UILabel *focusLabel;
@property (nonatomic ,weak  ) UIView *focusBgView;
@property (nonatomic ,strong) UIImageView *headerImageView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *fansLabel;
@property (nonatomic ,strong) UILabel *idLabel;

@end

@implementation QYZYLiveDetailViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self setsubviews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoginStatus) name:QYZYLoginSuccessNotification object:nil];
    [self setupPlayer];
    [self requestDetailData];
    [self removeOldDetailViewController];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.playerManager.player pause];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playerManager.player play];
}

- (void)setsubviews {
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(StatusBarHeight);
    }];
    [self.view addSubview:self.playerView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(8);
        make.top.equalTo(self.view).offset(StatusBarHeightConstant + 8);
        make.height.width.mas_equalTo(28);
    }];
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view).offset(-140);
        make.height.mas_equalTo(48);
        make.top.equalTo(self.playerView.mas_bottom);
    }];
    UIView *tempView = [[UIView alloc] init];
    tempView.backgroundColor = rgb(41, 69, 192);
    [self.view addSubview:tempView];
    [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.centerY.equalTo(self.categoryView);
        make.size.mas_equalTo(CGSizeMake(70, 48));
    }];
    self.focusBgView = tempView;
    [self.view addSubview:self.focusControl];
    [self.focusControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view);
        make.centerY.equalTo(self.categoryView);
        make.size.mas_equalTo(CGSizeMake(140, 48));
    }];
    [self.focusControl addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.focusControl).offset(6);
        make.centerY.equalTo(self.focusControl);
        make.width.height.mas_equalTo(36);
    }];
    [self.focusControl addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.focusControl).offset(46);
        make.top.equalTo(self.focusControl).offset(6);
        make.height.mas_equalTo(14);
        make.right.equalTo(self.focusControl).offset(-39);
    }];
    [self.focusControl addSubview:self.fansLabel];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.focusControl).offset(46);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(4);
        make.height.mas_equalTo(14);
        make.right.equalTo(self.focusControl).offset(-39);
    }];
    [self.focusControl addSubview:self.focusLabel];
    [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.focusControl);
        make.right.equalTo(self.focusControl);
        make.left.equalTo(self.nameLabel.mas_right);
    }];
    [self.categoryView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.categoryView);
        make.height.mas_equalTo(1);
    }];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];
    
    [self.view addSubview:self.idLabel];
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.categoryView);
    }];
}

- (void)removeOldDetailViewController {
    __block UIViewController *oldDetailViewController = nil;
    NSArray <__kindof UIViewController *> *viewControllers = UIViewController.currentViewController.navigationController.viewControllers;
    [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((idx < viewControllers.count - 1) && [obj isKindOfClass:QYZYLiveDetailViewController.class]) {
            oldDetailViewController = obj;
            *stop = YES;
        }
    }];
    if (oldDetailViewController) {
        UIViewController *currentVC = UIViewController.currentViewController;
        NSMutableArray *tempViewControllers = [NSMutableArray arrayWithArray:currentVC.navigationController.viewControllers];
        [tempViewControllers removeObject:oldDetailViewController];
        currentVC.navigationController.viewControllers = tempViewControllers;
    }
}

- (void)setupPlayer {
    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    self.playerManager = playerManager;
    self.player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:self.playerView];
    self.player.controlView = self.controlView;
    [self.player pauseWhenAppResignActive];
}

- (void)updateLoginStatus {
    weakSelf(self);
    [self.viewModel requestBaseInfoWithAnchorId:self.anchorId completion:^(NSDictionary * _Nonnull baseInfo) {
        strongSelf(self);
        if (baseInfo) {
            self.detailModel.focusStatus = baseInfo[@"fansType"];
            self.focusLabel.text = self.detailModel.focusStatus.integerValue ? @"已关注" : @"关注";
            [self updateFocusControl];
        }
    }];
}

- (void)updateFocusControl {
    if (self.detailModel.focusStatus.boolValue) {
        self.focusControl.backgroundColor = rgb(224, 228, 249);
        self.focusBgView.backgroundColor = rgb(224, 228, 249);
        self.nameLabel.textColor = rgb(97, 112, 152);
        self.fansLabel.textColor = rgb(97, 112, 152);
        self.focusLabel.textColor = rgb(97, 112, 152);
    }
    else {
        self.focusControl.backgroundColor = rgb(41, 69, 192);
        self.focusBgView.backgroundColor = rgb(41, 69, 192);
        self.nameLabel.textColor = UIColor.whiteColor;
        self.fansLabel.textColor = UIColor.whiteColor;
        self.focusLabel.textColor = UIColor.whiteColor;
    }
}

- (void)requestDetailData {
    dispatch_group_t request_group = dispatch_group_create();
    
    dispatch_group_enter(request_group);
    [self.viewModel requestPullInfoWithAnchorId:self.anchorId completion:^(NSDictionary * _Nonnull pullInfo) {
        self.detailModel.animUrl = [pullInfo[@"animUrl"] isKindOfClass:NSString.class] ? pullInfo[@"animUrl"] : @"";
        self.detailModel.playAddr = pullInfo[@"playAddr"];
        self.detailModel.liveTitle = pullInfo[@"liveTitle"];
        self.detailModel.chatId = [NSString stringWithFormat:@"%@", pullInfo[@"chatId"]];
        dispatch_group_leave(request_group);
    }];
    
    dispatch_group_enter(request_group);
    [self.viewModel requestBaseInfoWithAnchorId:self.anchorId completion:^(NSDictionary * _Nonnull baseInfo) {
        self.detailModel.leagueId = [NSString stringWithFormat:@"%@", baseInfo[@"leagueId"]];
        self.detailModel.isRobot = baseInfo[@"isRobot"];
        self.detailModel.fans = baseInfo[@"fans"];
        self.detailModel.focusStatus = baseInfo[@"fansType"];
        self.detailModel.nickname = baseInfo[@"nickname"];
        self.detailModel.userId = baseInfo[@"userId"];
        self.detailModel.headImageUrl = baseInfo[@"headImageUrl"];
        self.detailModel.profile = baseInfo[@"systemDesc"];
        self.detailModel.stb = baseInfo[@"stb"];
        if ([baseInfo[@"systemDesc"] isKindOfClass:NSNull.class]) {
            self.detailModel.profile = baseInfo[@"profile"];
        }
        dispatch_group_leave(request_group);
    }];
    
    dispatch_group_notify(request_group, dispatch_get_main_queue(), ^{
        self.focusLabel.text = self.detailModel.focusStatus.integerValue ? @"已关注" : @"关注";
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.headImageUrl]];
        self.fansLabel.text = [NSString stringWithFormat:@"%@ 粉丝",[NSString spelloutStringWithNumber:@(self.detailModel.fans.integerValue)]];
        self.nameLabel.text = self.detailModel.nickname;
        [self updateFocusControl];
        if ([QYZYBlockManager isBlockedByLeagueId:self.detailModel.leagueId]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailModel.animUrl]]];
            self.webView.hidden = NO;
        }
        else if ([self.detailModel.playAddr isKindOfClass:[NSDictionary class]]) {
            self.webView.hidden = YES;
            NSString *signRefer = [NSString stringWithFormat:@"Referer:%@",@"https://video.dqiu.com/"];
            ZFIJKPlayerManager *manager = self.player.currentPlayerManager;
            [manager.options setOptionValue:signRefer forKey:@"headers" ofCategory:kIJKFFOptionCategoryFormat];
            self.player.currentPlayerManager = manager;
            if ([self.detailModel.isRobot isEqualToNumber:@1]) {
                if ([self.detailModel.playAddr[@"flv"] length]) {
                    self.player.assetURL = [NSURL URLWithString:self.detailModel.playAddr[@"flv"]];
                }else if ([self.detailModel.playAddr[@"m3u8"] length]) {
                    self.player.assetURL = [NSURL URLWithString:self.detailModel.playAddr[@"m3u8"]];
                }else {
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailModel.animUrl]]];
                    self.webView.hidden = NO;
                }
            }else {
                if ([self.detailModel.playAddr[@"ld_flv"] length]) {
                    self.player.assetURL = [NSURL URLWithString:self.detailModel.playAddr[@"ld_flv"]];
                }else if ([self.detailModel.playAddr[@"ld_m3u8"] length]) {
                    self.player.assetURL = [NSURL URLWithString:self.detailModel.playAddr[@"ld_m3u8"]];
                }else {
                    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailModel.animUrl]]];
                    self.webView.hidden = NO;
                }
            }
        }
        else {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.detailModel.animUrl]]];
            self.webView.hidden = NO;
        }
        self.chatVC.chatId = self.detailModel.chatId;
        self.anchorVC.detailModel = self.detailModel;
        self.idLabel.text = [NSString stringWithFormat:@"主播ID: %@", self.detailModel.stb];
    });
}

- (void)focusAction {
    if (!QYZYUserManager.shareInstance.isLogin) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [UIViewController.currentViewController presentViewController:vc animated:true completion:nil];
        });
        return;
    }
    self.detailModel.focusStatus.integerValue ? [self loadAttentionCancelWithModel:self.detailModel] : [self loadAttentionWithModel:self.detailModel];
}

- (void)enterUserHomePage {
    QYZYPersonalhomepageViewController *personalVc = [[QYZYPersonalhomepageViewController alloc] init];
    personalVc.authorId = self.detailModel.userId;
    personalVc.hidesBottomBarWhenPushed = YES;
    [UIViewController.currentViewController.navigationController pushViewController:personalVc animated:YES];
}

- (void)loadAttentionWithModel:(QYZYLiveDetailModel *)model {
    QYZYNewsPostAttentionApi *api = [[QYZYNewsPostAttentionApi alloc] init];
    api.userId = model.userId;
    weakSelf(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        self.focusLabel.text = @"已关注";
        self.detailModel.focusStatus = @1;
        [self updateFocusControl];
        [self.view qyzy_showMsg:@"关注成功"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.view qyzy_showMsg:@"关注失败"];
    }];
}

- (void)loadAttentionCancelWithModel:(QYZYLiveDetailModel *)model {
    QYZYNewsPostAttentionCancelApi *api = [[QYZYNewsPostAttentionCancelApi alloc] init];
    api.userId = model.userId;
    weakSelf(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        self.focusLabel.text = @"关注";
        self.detailModel.focusStatus = @0;
        [self updateFocusControl];
        [self.view qyzy_showMsg:@"取消关注成功"];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.view qyzy_showMsg:@"取消关注失败"];
    }];
}

#pragma mark - delegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 3) {
        return self.moreVC;
    }
    else if (index == 2) {
        return self.rankVC;
    }
    else if (index == 0) {
        return self.chatVC;
    }
    else if (index == 1) {
        return self.anchorVC;
    }
    return nil;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArray.count;
}

#pragma mark - action
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (QYZYLiveDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYLiveDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (QYZYLiveDetailModel *)detailModel {
    if (!_detailModel) {
        _detailModel = [[QYZYLiveDetailModel alloc] init];
    }
    return _detailModel;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"live_detail_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.autoHiddenTimeInterval = 5;
        _controlView.autoFadeTimeInterval = 0.5;
        _controlView.prepareShowLoading = YES;
        _controlView.prepareShowControlView = NO;
        _controlView.portraitControlView.slider.hidden = YES;
        _controlView.portraitControlView.currentTimeLabel.hidden = YES;
        _controlView.portraitControlView.totalTimeLabel.hidden = YES;
        _controlView.landScapeControlView.slider.hidden = YES;
        _controlView.landScapeControlView.currentTimeLabel.hidden = YES;
        _controlView.landScapeControlView.totalTimeLabel.hidden = YES;
    }
    return _controlView;
}

- (UIImageView *)playerView {
    if (!_playerView) {
        _playerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_detail_bg"]];
        _playerView.contentMode = UIViewContentModeScaleAspectFill;
        CGFloat width = CGRectGetWidth(self.view.bounds);
        _playerView.frame = CGRectMake(0, StatusBarHeight, width, 9.0/16.0*width);
    }
    return _playerView;
}

- (WKWebView *)webView {
    if (!_webView) {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, width, 9.0/16.0*width) configuration:[[WKWebViewConfiguration alloc] init]];
        _webView.hidden = YES;
    }
    return _webView;
}

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = UIColor.blackColor;
    }
    return _statusView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        _categoryView.titles = self.titleArray;
        _categoryView.titleColor = rgb(34, 34, 34);
        _categoryView.titleSelectedColor = rgb(41, 69, 192);
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _categoryView.cellWidth = 54;
        _categoryView.cellSpacing = 0;
        _categoryView.backgroundColor = UIColor.whiteColor;
        _categoryView.listContainer = self.containerView;
        
        JXCategoryIndicatorLineView *indicator = [[JXCategoryIndicatorLineView alloc] init];
        indicator.indicatorColor = rgb(41, 69, 192);
        indicator.indicatorWidth = 15;
        indicator.indicatorHeight = 3;
        indicator.indicatorCornerRadius = 1.5;
        indicator.indicatorWidthIncrement = 0;
        indicator.verticalMargin = 2;
        _categoryView.indicators = @[indicator];
    }
    return _categoryView;
}

- (NSArray *)titleArray {
    return @[@"聊天",@"主播",@"排行榜",@"更多"];
}

- (JXCategoryListContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    }
    return _containerView;
}

- (QYZYLiveMoreViewController *)moreVC {
    if (!_moreVC) {
        _moreVC = [[QYZYLiveMoreViewController alloc] init];
        _moreVC.anchorId = self.anchorId;
    }
    return _moreVC;
}

- (QYZYLiveRankViewController *)rankVC {
    if (!_rankVC) {
        _rankVC = [[QYZYLiveRankViewController alloc] init];
        _rankVC.anchorId = self.anchorId;
    }
    return _rankVC;
}

- (QYZYLiveChatViewController *)chatVC {
    if (!_chatVC) {
        _chatVC = [[QYZYLiveChatViewController alloc] init];
        _chatVC.anchorId = self.anchorId;
    }
    return _chatVC;
}

- (QYZYLiveAnchorViewController *)anchorVC {
    if (!_anchorVC) {
        _anchorVC = [[QYZYLiveAnchorViewController alloc] init];
        _anchorVC.anchorId = self.anchorId;
    }
    return _anchorVC;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = rgb(248, 249, 254);
    }
    return _lineView;
}

- (UIControl *)focusControl {
    if (!_focusControl) {
        _focusControl = [[UIControl alloc] init];
        _focusControl.backgroundColor = rgb(41, 69, 192);
        [_focusControl addTarget:self action:@selector(focusAction) forControlEvents:UIControlEventTouchUpInside];
        _focusControl.layer.cornerRadius = 24;
    }
    return _focusControl;
}

- (UILabel *)focusLabel {
    if (!_focusLabel) {
        _focusLabel = [[UILabel alloc] init];
        _focusLabel.textColor = UIColor.whiteColor;
        _focusLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _focusLabel.text = @"关注";
        _focusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _focusLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.backgroundColor = rgb(248, 248, 248);
        _headerImageView.layer.cornerRadius = 18;
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        _headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterUserHomePage)];
        [_headerImageView addGestureRecognizer:tap];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColor.whiteColor;
        _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _nameLabel;
}

- (UILabel *)fansLabel {
    if (!_fansLabel) {
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.textColor = UIColor.whiteColor;
        _fansLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    }
    return _fansLabel;
}

- (UILabel *)idLabel {
    if (_idLabel == nil) {
        _idLabel = [[UILabel alloc] init];
        _idLabel.textColor = UIColor.blackColor;
        _idLabel.font = [UIFont systemFontOfSize:10];
    }
    return _idLabel;
}

@end
