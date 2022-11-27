//
//  QYZYLiveViewController.m
//  QYZY
//
//  Created by jsmaster on 9/27/22.
//

#import "QYZYLiveViewController.h"
#import "QYZYLiveMainViewController.h"
#import "QYZYFootballViewController.h"
#import "QYZYAppointmentViewController.h"
#import "QYZYRankViewController.h"
#import "QYZYSearchController.h"
#import "QYZYPhoneLoginViewController.h"
#import "QYZYLiveDetailViewController.h"

@interface QYZYLiveViewController ()<JXCategoryViewDelegate ,JXCategoryListContainerViewDelegate >
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *containerView;
@property (nonatomic, strong) QYZYLiveMainViewController *liveMainVC;
@property (nonatomic, strong) QYZYFootballViewController *footballVC;
@end

@implementation QYZYLiveViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
}

- (void)setupSubViews {
    
//    self.categoryView.frame = CGRectMake(0, 0, 180, 32);
//    self.navigationItem.titleView = self.categoryView;
//
    UIView *searchBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 115, 32)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick)];
    [searchBgView addGestureRecognizer:tap];
    searchBgView.backgroundColor = UIColor.whiteColor;
    searchBgView.layer.cornerRadius = 16;
    searchBgView.layer.masksToBounds = YES;
    self.leftItem = searchBgView;
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(8, 4, 24, 24)];
    UIImage *image = [[UIImage imageNamed:@"iconSousuo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [searchButton setImage:image forState:UIControlStateNormal];
    searchButton.tintColor = rgb(149, 157, 176);
    searchButton.userInteractionEnabled = NO;
    [searchBgView addSubview:searchButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 6, 112, 20)];
    titleLabel.text = @"请输入主播或赛事";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    titleLabel.textColor = rgb(164, 169, 181);
    [searchBgView addSubview:titleLabel];
    
    UIView *rightItem = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 62, 44)];
    
    UIButton *rankButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 26, 44)];
    [rankButton setImage:[UIImage imageNamed:@"iconPaihng"] forState:UIControlStateNormal];
    [rankButton addTarget:self action:@selector(rankClick) forControlEvents:UIControlEventTouchUpInside];
    [rightItem addSubview:rankButton];
    
    UIButton *focusButton = [[UIButton alloc]initWithFrame:CGRectMake(32, 0, 26, 44)];
    [focusButton setImage:[UIImage imageNamed:@"iconYuyue"] forState:UIControlStateNormal];
    [focusButton addTarget:self action:@selector(focusClick) forControlEvents:UIControlEventTouchUpInside];
    [rightItem addSubview:focusButton];
    self.rightItem = rightItem;
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

//点击搜索
- (void)searchClick
{
    QYZYSearchController *vc = [[QYZYSearchController alloc]init];
    weakSelf(self)
    vc.goToLivePageBlock = ^(NSString * _Nonnull anchorId) {
        strongSelf(self)
        QYZYLiveDetailViewController *vc = [[QYZYLiveDetailViewController alloc] init];
        vc.anchorId = anchorId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

//排行榜
- (void)rankClick
{
    QYZYRankViewController *vc = [[QYZYRankViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

//关注
- (void)focusClick
{
    if (QYZYUserManager.shareInstance.isLogin == false) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            QYZYPhoneLoginViewController *vc = [QYZYPhoneLoginViewController new];
            [self presentViewController:vc animated:true completion:nil];
        });
        
        return;
    }
    
    QYZYAppointmentViewController *vc = [[QYZYAppointmentViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - delegate
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return categoryView.selectedIndex != index;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return self.liveMainVC;
    }
    if (index == 1) {
        return self.footballVC;
    }
    return (id<JXCategoryListContentViewDelegate>)UIViewController.new;
}


#pragma mark - get
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titles = @[@"直播",@"赛程"];
        _categoryView.titleColor = rgb(196, 220, 255);
        _categoryView.titleSelectedColor = rgb(12, 35, 137);
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _categoryView.cellWidth = 87;
        _categoryView.cellSpacing = 0;
        _categoryView.delegate = self;
        _categoryView.listContainer = self.containerView;
        _categoryView.backgroundColor = rgb(12, 35, 137);
        _categoryView.layer.masksToBounds = NO;
        _categoryView.layer.cornerRadius = 4.0;
        
        
        JXCategoryIndicatorBackgroundView *indicator = [[JXCategoryIndicatorBackgroundView alloc] init];
        indicator.indicatorColor = rgb(254, 254, 255);
        indicator.indicatorWidth = 87;
        indicator.indicatorHeight = 28;
        indicator.indicatorCornerRadius = 4;
        indicator.indicatorWidthIncrement = 0;
        _categoryView.indicators = @[indicator];
        
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        _containerView.listCellBackgroundColor = UIColor.clearColor;
        _containerView.scrollView.backgroundColor = UIColor.clearColor;
    }
    return _containerView;
}

- (QYZYLiveMainViewController *)liveMainVC {
    if (!_liveMainVC) {
        _liveMainVC = [[QYZYLiveMainViewController alloc] init];
    }
    return _liveMainVC;
}


- (QYZYFootballViewController *)footballVC
{
    if (!_footballVC) {
        _footballVC = [[QYZYFootballViewController alloc]init];
    }
    return _footballVC;
}
@end
