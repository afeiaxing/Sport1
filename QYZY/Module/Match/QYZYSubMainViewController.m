//
//  QYZYSubMainViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYSubMainViewController.h"
#import "QYZYMatchSubViewController.h"
#import "QYZYMatchViewModel.h"

@interface QYZYSubMainViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic ,strong) JXCategoryTitleView *categoryView;
@property (nonatomic ,strong) JXCategoryListContainerView *containerView;
@property (nonatomic ,strong) QYZYMatchViewModel *viewModel;
@property (nonatomic ,strong) QYZYMatchSubViewController *finishedVC;
@property (nonatomic ,strong) QYZYMatchSubViewController *goingVC;
@property (nonatomic ,strong) QYZYMatchSubViewController *uncomingVC;
@end

@implementation QYZYSubMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupSubViews];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:QYZYNetworkingFirstAvaliableNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (UIView *)listView {
    return self.view;
}

- (void)setupSubViews {
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(48);
    }];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom);
    }];
}

- (void)requestData {
    weakSelf(self);
    [self.viewModel requestMatchDataWithDateString:self.currentDateString completion:^(QYZYMatchModel * _Nonnull matchModel) {
        strongSelf(self);
        [self.goingVC endRefresh];
        [self.finishedVC endRefresh];
        [self.uncomingVC endRefresh];
        if (matchModel) {
            self.goingVC.matches = matchModel.going.matches;
            self.finishedVC.matches = matchModel.finished.matches;
            self.uncomingVC.matches = matchModel.uncoming.matches;
        }
    }];
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
        return self.goingVC;
    }
    else if (index == 1) {
        return self.finishedVC;
    }
    else {
        return self.uncomingVC;
    }
}

#pragma mark - get
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        _categoryView.titles = @[@"进行中",@"已结束",@"未开赛"];
        _categoryView.titleColor = UIColor.whiteColor;
        _categoryView.titleSelectedColor = rgb(41, 69, 192);
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _categoryView.cellWidth = 78;
        _categoryView.cellSpacing = 0;
        _categoryView.backgroundColor = rgb(41, 69, 192);
        _categoryView.listContainer = self.containerView;
        _categoryView.delegate = self;
        
        JXCategoryIndicatorBackgroundView *indicator = [[JXCategoryIndicatorBackgroundView alloc] init];
        indicator.indicatorColor = rgb(254, 254, 255);
        indicator.indicatorWidth = 78;
        indicator.indicatorHeight = 28;
        indicator.indicatorCornerRadius = 14;
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

- (QYZYMatchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYMatchViewModel alloc] init];
        _viewModel.matchType = self.matchType;
    }
    return _viewModel;
}

- (QYZYMatchSubViewController *)goingVC {
    if (!_goingVC) {
        _goingVC = [[QYZYMatchSubViewController alloc] init];
        weakSelf(self);
        _goingVC.requestBlock = ^{
            strongSelf(self);
            [self requestData];
        };
    }
    return _goingVC;
}

- (QYZYMatchSubViewController *)finishedVC {
    if (!_finishedVC) {
        _finishedVC = [[QYZYMatchSubViewController alloc] init];
        weakSelf(self);
        _finishedVC.requestBlock = ^{
            strongSelf(self);
            [self requestData];
        };
    }
    return _finishedVC;
}

- (QYZYMatchSubViewController *)uncomingVC {
    if (!_uncomingVC) {
        _uncomingVC = [[QYZYMatchSubViewController alloc] init];
        weakSelf(self);
        _uncomingVC.requestBlock = ^{
            strongSelf(self);
            [self requestData];
        };
    }
    return _uncomingVC;
}

@end
