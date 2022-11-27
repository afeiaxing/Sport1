//
//  QYZYMatchDetailViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYMatchDetailViewController.h"
#import "QYZYLiveChatViewController.h"
#import "QYZYMatchOverViewController.h"
#import "QYZYMatchAnalyzeViewController.h"
#import "QYZYBasketballOverviewController.h"
#import "QYZYMatchViewModel.h"
#import <WebKit/WebKit.h>

@interface QYZYMatchDetailViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic ,strong) UIView *statusView;
@property (nonatomic ,strong) UIImageView *bgImageView;
@property (nonatomic ,strong) UIView *headerBgView;
@property (nonatomic ,strong) UILabel *leagueLabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic ,strong) UILabel *statusLabel;
@property (nonatomic ,strong) UIImageView *hostImageView;
@property (nonatomic ,strong) UIImageView *guestImageView;
@property (nonatomic ,strong) UILabel *hostLabel;
@property (nonatomic ,strong) UILabel *guestLabel;
@property (nonatomic ,strong) UIButton *playButton;
@property (nonatomic ,strong) UILabel *scoreLabel;
@property (nonatomic ,strong) UILabel *halfScoreLabel;

@property (nonatomic ,strong) QYZYMatchViewModel *viewModel;
@property (nonatomic ,strong) QYZYMatchMainModel *mainModel;
@property (nonatomic ,strong) WKWebView *webView;
@property (nonatomic ,strong) UIButton *backButton;
@property (nonatomic ,strong) QYZYLiveChatViewController *chatVC;
@property (nonatomic ,strong) QYZYMatchOverViewController *overVC;
@property (nonatomic ,strong) QYZYBasketballOverviewController *basketballOverVc;
@property (nonatomic ,strong) QYZYMatchAnalyzeViewController *analyzeVC;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *containerView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation QYZYMatchDetailViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerLoadDetailData) userInfo:nil repeats:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupSubViews];
    [self requestData];
    [self removeOldDetailViewController];
}

- (void)setupSubViews {
    [self.view addSubview:self.statusView];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(StatusBarHeightConstant);
    }];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.statusView.mas_bottom);
        make.height.mas_equalTo(9.0/16.0*width);
    }];
    [self.view addSubview:self.headerBgView];
    [self.headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(9.0/16.0*width + StatusBarHeightConstant);
    }];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.statusView.mas_bottom);
        make.height.mas_equalTo(9.0/16.0*width);
    }];
    [self.view addSubview:self.backButton];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(8);
        make.top.equalTo(self.view).offset(StatusBarHeightConstant + 8);
        make.height.width.mas_equalTo(28);
    }];
    [self.headerBgView addSubview:self.leagueLabel];
    [self.leagueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerBgView);
        make.top.equalTo(self.headerBgView).offset(StatusBarHeightConstant + 6);
        make.height.mas_equalTo(17);
    }];
    [self.headerBgView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leagueLabel);
        make.top.equalTo(self.leagueLabel.mas_bottom);
        make.height.mas_equalTo(16);
    }];
    [self.headerBgView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerBgView);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(17);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(30);
    }];
    [self.headerBgView addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leagueLabel);
        make.bottom.equalTo(self.headerBgView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(80, 24));
    }];
    [self.headerBgView addSubview:self.hostImageView];
    [self.hostImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerBgView).offset(38);
        make.width.height.mas_equalTo(50);
        make.bottom.equalTo(self.headerBgView).offset(-80);
    }];
    [self.headerBgView addSubview:self.hostLabel];
    [self.hostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hostImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(18);
        make.centerX.equalTo(self.hostImageView);
    }];
    [self.headerBgView addSubview:self.guestImageView];
    [self.guestImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerBgView).offset(-38);
        make.width.height.mas_equalTo(50);
        make.bottom.equalTo(self.headerBgView).offset(-80);
    }];
    [self.headerBgView addSubview:self.guestLabel];
    [self.guestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guestImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(18);
        make.centerX.equalTo(self.guestImageView);
    }];
    [self.headerBgView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerBgView);
        make.bottom.equalTo(self.hostImageView.mas_bottom);
        make.height.mas_equalTo(32);
    }];
    [self.headerBgView addSubview:self.halfScoreLabel];
    [self.halfScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerBgView);
        make.top.equalTo(self.scoreLabel.mas_bottom).offset(6);
        make.height.mas_equalTo(16);
    }];
    
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(48);
        make.top.equalTo(self.headerBgView.mas_bottom);
    }];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];
}

- (void)removeOldDetailViewController {
    __block UIViewController *oldDetailViewController = nil;
    NSArray <__kindof UIViewController *> *viewControllers = UIViewController.currentViewController.navigationController.viewControllers;
    [viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((idx < viewControllers.count - 1) && [obj isKindOfClass:self.class]) {
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

- (void)requestData {
    weakSelf(self);
    [self.viewModel requestMatchDetailWithMatchId:self.matchId completion:^(QYZYMatchMainModel * _Nonnull detailModel) {
        strongSelf(self);
        if (detailModel) {
            self.mainModel = detailModel;
            [self updateHeaderWithDetailModel:detailModel];
            if (detailModel.animUrl.length) {
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailModel.animUrl]]];
            } else if (detailModel.obliqueAnimUrl.length) {
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:detailModel.obliqueAnimUrl]]];
            }
            self.chatVC.chatId = detailModel.matchId;
            self.analyzeVC.detailModel = detailModel;
            if (detailModel.sportId.integerValue == 2) {
                self.basketballOverVc.detailModel = detailModel;
            }else {
                self.overVC.detailModel = detailModel;
            }
        }
    }];
}

- (void)updateHeaderWithDetailModel:(QYZYMatchMainModel *)detailModel {
    if ([detailModel.sportId isEqualToString:@"1"]) {
        self.headerBgView.backgroundColor = rgb(15, 100, 51);
        self.leagueLabel.text = [NSString stringWithFormat:@"%@%@",detailModel.leagueNick,detailModel.round ?: @""];
    } else {
        self.headerBgView.backgroundColor = rgb(33, 67, 132);
        self.leagueLabel.text = [NSString stringWithFormat:@"%@%@",detailModel.leagueNick,detailModel.groupName ?: @""];
    }
    self.timeLabel.text = [self time_timestampToString:detailModel.matchTime.integerValue];
    [self.hostImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.hostTeamLogo]];
    self.hostImageView.backgroundColor = detailModel.hostTeamLogo.length ? UIColor.clearColor : rgba(255, 255, 255, 0.15);
    self.hostLabel.text = detailModel.hostTeamName;
    [self.guestImageView sd_setImageWithURL:[NSURL URLWithString:detailModel.guestTeamLogo]];
    self.guestImageView.backgroundColor = detailModel.guestTeamLogo.length ? UIColor.clearColor : rgba(255, 255, 255, 0.15);
    self.guestLabel.text = detailModel.guestTeamName;
    self.scoreLabel.text = [NSString stringWithFormat:@"%@ - %@",detailModel.hostTeamScore ?: @"0", detailModel.guestTeamScore ?: @"0"];
    self.halfScoreLabel.text = [NSString stringWithFormat:@"(%@-%@)",detailModel.hostTeamHalfScore ?: @"0", detailModel.guestTeamHalfScore ?: @"0"];
    self.statusLabel.text = [self getStatusCode:detailModel.matchStatusCode.integerValue timePlayed:detailModel.timePlayed.integerValue MatchTime:@(detailModel.matchTime.integerValue) status:detailModel.matchStatus.integerValue detailModel:detailModel];
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGFloat width = [self.statusLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options:options attributes:@{NSFontAttributeName : self.statusLabel.font} context:nil].size.width;
    [self.statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width + 12);
    }];
}

- (void)timerLoadDetailData {
    weakSelf(self);
    [self.viewModel requestMatchDetailWithMatchId:self.matchId completion:^(QYZYMatchMainModel * _Nonnull detailModel) {
        strongSelf(self);
        if (detailModel) {
            self.mainModel = detailModel;
            [self updateHeaderWithDetailModel:detailModel];
        }
    }];
}

#pragma mark - delegate
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return self.chatVC;
    }
    else if (index == 1) {
        if (self.mainModel.sportId.integerValue == 2) {
            return self.basketballOverVc;
        }
        return self.overVC;
    }
    else {
        return self.analyzeVC;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titleArray.count;
}

#pragma mark - action
- (void)backAction {
    if (!self.webView.hidden) {
        self.webView.hidden = YES;
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playAction {
    if (self.mainModel.animUrl.length || self.mainModel.obliqueAnimUrl.length) {
        self.webView.hidden = NO;
    } else {
        self.webView.hidden = YES;
        [self.view qyzy_showMsg:@"暂无动画"];
    }
}

#pragma mark - get
- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = UIColor.blackColor;
    }
    return _statusView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"live_detail_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_detail_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UIView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [[UIView alloc] init];
        _headerBgView.backgroundColor = rgb(15, 100, 51);
    }
    return _headerBgView;
}

- (UILabel *)leagueLabel {
    if (!_leagueLabel) {
        _leagueLabel = [[UILabel alloc] init];
        _leagueLabel.textColor = UIColor.whiteColor;
        _leagueLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    }
    return _leagueLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = rgba(255, 255, 255, 0.8);
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _timeLabel;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.backgroundColor = rgba(255, 255, 255, 0.15);
        _statusLabel.layer.cornerRadius = 12;
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.textColor = rgba(255, 255, 255, 0.7);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = [UIFont fontWithName:@"PingFangHK-Regular" size:12];
    }
    return _statusLabel;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setTitle:@"观看动画" forState:UIControlStateNormal];
        [_playButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _playButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _playButton.backgroundColor = rgba(255, 255, 255, 0.25);
        _playButton.layer.borderColor = rgba(255, 255, 255, 0.1).CGColor;
        _playButton.layer.borderWidth = 0.5;
        _playButton.layer.cornerRadius = 12;
        _playButton.layer.masksToBounds = YES;
        [_playButton addTarget:self action:@selector(playAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIImageView *)hostImageView {
    if (!_hostImageView) {
        _hostImageView = [[UIImageView alloc] init];
        _hostImageView.backgroundColor = rgba(255, 255, 255, 0.15);
    }
    return _hostImageView;
}

- (UIImageView *)guestImageView {
    if (!_guestImageView) {
        _guestImageView = [[UIImageView alloc] init];
        _guestImageView.backgroundColor = rgba(255, 255, 255, 0.15);
    }
    return _guestImageView;
}

- (UILabel *)hostLabel {
    if (!_hostLabel) {
        _hostLabel = [[UILabel alloc] init];
        _hostLabel.textColor = UIColor.whiteColor;
        _hostLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _hostLabel;
}

- (UILabel *)guestLabel {
    if (!_guestLabel) {
        _guestLabel = [[UILabel alloc] init];
        _guestLabel.textColor = UIColor.whiteColor;
        _guestLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _guestLabel;
}

- (UILabel *)scoreLabel {
    if (!_scoreLabel) {
        _scoreLabel = [[UILabel alloc] init];
        _scoreLabel.textColor = UIColor.whiteColor;
        _scoreLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:32];
    }
    return _scoreLabel;
}

- (UILabel *)halfScoreLabel {
    if (!_halfScoreLabel) {
        _halfScoreLabel = [[UILabel alloc] init];
        _halfScoreLabel.textColor = UIColor.whiteColor;
        _halfScoreLabel.font = [UIFont fontWithName:@"PingFangHK-Regular" size:12];
    }
    return _halfScoreLabel;
}

- (QYZYMatchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYMatchViewModel alloc] init];
    }
    return _viewModel;
}

- (WKWebView *)webView {
    if (!_webView) {
        CGFloat width = CGRectGetWidth(self.view.bounds);
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, StatusBarHeight, width, 9.0/16.0*width) configuration:[[WKWebViewConfiguration alloc] init]];
        _webView.hidden = YES;
    }
    return _webView;
}

- (QYZYLiveChatViewController *)chatVC {
    if (!_chatVC) {
        _chatVC = [[QYZYLiveChatViewController alloc] init];
        _chatVC.anchorId = @"";
    }
    return _chatVC;
}

- (QYZYMatchOverViewController *)overVC {
    if (!_overVC) {
        _overVC = [[QYZYMatchOverViewController alloc] init];
        _overVC.matchId = self.matchId;
    }
    return _overVC;
}

- (QYZYBasketballOverviewController *)basketballOverVc {
    if (!_basketballOverVc) {
        _basketballOverVc = [[QYZYBasketballOverviewController alloc] init];
        _basketballOverVc.matchId = self.matchId;
    }
    return _basketballOverVc;
}

- (QYZYMatchAnalyzeViewController *)analyzeVC {
    if (!_analyzeVC) {
        _analyzeVC = [[QYZYMatchAnalyzeViewController alloc] init];
    }
    return _analyzeVC;
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
    return @[@"在线聊球",@"比赛实况",@"数据分析"];
}

- (JXCategoryListContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    }
    return _containerView;
}

#pragma mark - help
- (NSString *)time_timestampToString:(NSInteger)timestamp{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString* string=[dateFormat stringFromDate:confromTimesp];
    return string;
}

///比赛状态
- (NSString *)getStatusCode:(NSInteger)statusCode
                 timePlayed:(NSInteger)timePlayed
                  MatchTime:(NSNumber *)matchTime
                     status:(NSInteger)status
            detailModel:(QYZYMatchMainModel *)detailModel {
    if (!matchTime) {
        matchTime = @0;
    }
    if (timePlayed < 0) {
        timePlayed = 0;
    }
    NSString * statusString = @"未知";
    switch (statusCode) {
        case 0:
            statusString = @"未";
            break;
        case 1:
        {
            if ([detailModel.sportId isEqualToString:@"1"]) {
                NSInteger minute = 0;
                if (timePlayed == 0) {
                    NSInteger interval = [[NSDate date] timeIntervalSince1970];
                    minute = (interval - matchTime.integerValue / 1000.0) / 60;
                } else {
                    minute = ceilf(timePlayed / 60.0);
                }
                if (minute < 0) minute = 0;
                if (minute > 45) {
                    statusString = @"45+";
                } else {
                    statusString = [NSString stringWithFormat:@"%zd",minute];
                }
            } else {
                statusString = @"上半场";
            }
        }
            break;
        case 2:
        {
            if ([detailModel.sportId isEqualToString:@"1"]) {
                NSInteger minute = 0;
                if (timePlayed == 0) {
                    NSInteger interval = [[NSDate date] timeIntervalSince1970];
                    minute = (interval - matchTime.integerValue / 1000.0) / 60 - 15;
                } else {
                    minute = ceilf(timePlayed / 60.0);
                }
                if (minute > 90) {
                    statusString = @"90+";
                } else {
                    statusString = [NSString stringWithFormat:@"%zd",minute];
                }
            } else {
                statusString = @"下半场";
            }
        }
            break;
        case 10:
        {
            NSInteger interval = [[NSDate date] timeIntervalSince1970];
            NSInteger minute = (interval - matchTime.integerValue / 1000.0) / 60;
            if ([detailModel.sportId isEqualToString:@"1"]) {
                if (timePlayed != 0) {
                    minute = ceilf(timePlayed / 60.0);
                }
                statusString = [NSString stringWithFormat:@"%zd",minute];
                break;
            } else if ([detailModel.sportId isEqualToString:@"2"]) {
                if (minute <= 3) {
                    statusString = @"第一节";
                    break;
                }
            }
            statusString = @"进行中";
        }
            break;
        case 11:
        case 12:
        case 13:
        case 14:
            statusString = [NSString stringWithFormat:@"第%@节",[self numberToString:statusCode - 10]];
            break;
//        case XMMatchBallStatusOvertime:
        case 21:
        case 22:
            if ([detailModel.sportId isEqualToString:@"1"]) {
                NSInteger minute = 0;
                if (timePlayed == 0) {
                    NSInteger interval = [[NSDate date] timeIntervalSince1970];
                    minute = (interval - matchTime.integerValue / 1000.0) / 60 - 15;
                } else {
                    minute = ceilf(timePlayed / 60.0);
                }
                statusString = [NSString stringWithFormat:@"%zd",minute];
            }
            break;
        case 25:
            statusString = @"点球";
            break;
        case 30:
            statusString = @"暂停";
            break;
        case 31:
            statusString = @"中";
            break;
        case 35:
        case 36:
            statusString = @"点球";
            break;
        case 40:
            statusString = @"取消";
            break;
        case 41:
            statusString = @"延期";
            break;
        case 42:
            statusString = @"推迟";
            break;
        case 43:
            statusString = @"中断";
            break;
        case 100:
            statusString = @"完";
            break;
        case 404:
            statusString = @"未知";
            break;
        default:
            break;
    }
    
    if ([detailModel.sportId isEqualToString:@"2"]) {
        if (statusCode == 11 ||
            statusCode == 12 ||
            statusCode == 13 ||
            statusCode == 14 ||
            statusCode == 1 ||
            statusCode == 2 ||
            (statusCode == 20)) {
            NSInteger minute = (timePlayed) / 60.0;
            NSInteger second = (timePlayed) % 60;
            statusString = [NSString stringWithFormat:@"%@ %02ld:%02ld",statusString,minute,second];
        }
    }
    
    if (status == 3 ||
        statusCode == 100) {
        statusString = @"完";
    }
    return statusString;
}

- (NSString *)numberToString:(NSInteger)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];// 如果不设置locle 跟随系统语言
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    return [formatter stringFromNumber:[NSNumber numberWithInteger:number]];
}

@end
