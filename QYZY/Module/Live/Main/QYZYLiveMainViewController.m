//
//  QYZYLiveMainViewController.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveMainViewController.h"
#import "QYZYLiveHomeViewController.h"

#import "JXPagerView.h"
#import "QYZYLiveMainHeaderView.h"
#import "QYZYLiveMainViewModel.h"

@interface QYZYLiveMainViewController ()<JXPagerViewDelegate>
@property (nonatomic ,strong) JXPagerView *pagerView;
@property (nonatomic ,strong) QYZYLiveMainHeaderView *pagerHeaderView;
@property (nonatomic ,strong) JXCategoryTitleView *categoryView;
@property (nonatomic ,strong) QYZYLiveMainViewModel *viewModel;
@property (nonatomic ,strong) NSArray <QYZYLiveHomeViewController *> *vcArray;
@property (nonatomic ,strong) NSArray <NSString *> *titleArray;
@end

@implementation QYZYLiveMainViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.clearColor;
    if (@available(ios 15.0, *)) {
        UITableView.appearance.sectionHeaderTopPadding = 0;
    }
    [self setupSubViews];
    [self requestGroup];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestGroup) name:QYZYNetworkingFirstAvaliableNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupSubViews {
    [self.view addSubview:self.pagerView];
    [self.pagerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)requestGroup {
    weakSelf(self);
    [self.viewModel requestGroupListWithCompletion:^(NSArray<QYZYLiveMainGroupModel *> * _Nonnull groupArray ,NSString *msg) {
        strongSelf(self);
        [self.pagerView.mainTableView.mj_header endRefreshing];
        if (!msg) {
            NSMutableArray <NSString *> *titleArray = [NSMutableArray array];
            NSMutableArray <QYZYLiveHomeViewController *> *vcArray = [NSMutableArray array];
            [groupArray enumerateObjectsUsingBlock:^(QYZYLiveMainGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titleArray addObject:obj.liveGroupName];
                QYZYLiveHomeViewController *vc = [[QYZYLiveHomeViewController alloc] init];
                vc.liveGroupId = obj.liveGroupId;
                [vcArray addObject:vc];
            }];
            self.vcArray = vcArray;
            self.titleArray = titleArray;
            self.categoryView.titles = titleArray;
            [self.categoryView reloadData];
            [self.pagerView reloadData];
        }
    }];
    [self.viewModel requestHotListWithCompletion:^(NSArray<QYZYLiveMainHotModel *> * hotArray, NSString * msg) {
        strongSelf(self);
        [self.pagerView.mainTableView.mj_header endRefreshing];
        if (!msg) {
            self.pagerHeaderView.hotArray = hotArray;
        }
    }];
    [self.viewModel requestLiveBannerWithCompletion:^(NSArray<QYZYLiveBannerModel *> * _Nonnull bannerArray, NSString * _Nonnull msg) {
        strongSelf(self);
        [self.pagerView.mainTableView.mj_header endRefreshing];
        if (!msg) {
            self.pagerHeaderView.bannerArray = bannerArray;
        }
    }];
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return 320;
}

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.pagerHeaderView;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 48;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.categoryView.titles.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    return self.vcArray[index];
}

//#pragma mark - JXPagerMainTableViewGestureDelegate
//- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    //禁止categoryView左右滑动的时候，上下和左右都可以滚动
//    if (otherGestureRecognizer == self.categoryView.contentScrollView.panGestureRecognizer) {
//        return NO;
//    }
//
//    return NO;
//    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
//}

- (JXPagerView *)pagerView {
    if (!_pagerView) {
        _pagerView = [[JXPagerView alloc] initWithDelegate:self listContainerType:JXPagerListContainerType_CollectionView];
        _pagerView.mainTableView.backgroundColor = UIColor.clearColor;
        weakSelf(self);
        _pagerView.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            strongSelf(self);
            [self requestGroup];
        }];
    }
    return _pagerView;
}

- (QYZYLiveMainHeaderView *)pagerHeaderView {
    if (!_pagerHeaderView) {
        _pagerHeaderView = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(QYZYLiveMainHeaderView.class) owner:self options:nil].firstObject;
    }
    return _pagerHeaderView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        _categoryView.titles = self.titleArray;
        _categoryView.titleColor = UIColor.whiteColor;
        _categoryView.titleSelectedColor = rgb(41, 69, 192);
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _categoryView.cellWidth = 54;
        _categoryView.cellSpacing = 0;
        _categoryView.backgroundColor = rgb(41, 69, 192);
        _categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagerView.listContainerView;
        
        JXCategoryIndicatorBackgroundView *indicator = [[JXCategoryIndicatorBackgroundView alloc] init];
        indicator.indicatorColor = rgb(254, 254, 255);
        indicator.indicatorWidth = 54;
        indicator.indicatorHeight = 28;
        indicator.indicatorCornerRadius = 14;
        indicator.indicatorWidthIncrement = 0;
        _categoryView.indicators = @[indicator];
    }
    return _categoryView;
}

- (QYZYLiveMainViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYLiveMainViewModel alloc] init];
    }
    return _viewModel;
}

@end
