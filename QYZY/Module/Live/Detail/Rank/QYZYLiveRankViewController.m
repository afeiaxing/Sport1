//
//  QYZYLiveRankViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import "QYZYLiveRankViewController.h"
#import "QYZYLiveRankSubViewController.h"

@interface QYZYLiveRankViewController ()<JXCategoryViewDelegate ,JXCategoryListContainerViewDelegate>

@property (nonatomic ,strong) JXCategoryTitleView *categoryView;
@property (nonatomic ,strong) JXCategoryListContainerView *containerView;
@property (nonatomic ,strong) QYZYLiveRankSubViewController *dayRank;
@property (nonatomic ,strong) QYZYLiveRankSubViewController *weekRank;

@end

@implementation QYZYLiveRankViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setsubView];
}

- (void)setsubView {
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(210, 30));
        make.top.equalTo(self.view).offset(13);
        make.centerX.equalTo(self.view);
    }];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom).offset(12);
    }];
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return self.dayRank;
    } else {
        return self.weekRank;
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.layer.cornerRadius = 15;
        _categoryView.layer.masksToBounds = YES;
        _categoryView.layer.borderColor = rgb(41, 69, 192).CGColor;
        _categoryView.layer.borderWidth = 1;
        _categoryView.titles = @[@"日榜",@"周榜"];
        _categoryView.titleColor = rgb(34, 34, 34);
        _categoryView.titleSelectedColor = UIColor.whiteColor;
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _categoryView.cellWidth = 105;
        _categoryView.cellSpacing = 0;
        _categoryView.listContainer = self.containerView;
        
        JXCategoryIndicatorBackgroundView *indicator = [[JXCategoryIndicatorBackgroundView alloc] init];
        indicator.indicatorColor = rgb(41, 69, 192);
        indicator.indicatorWidth = 105;
        indicator.indicatorHeight = 30;
        indicator.indicatorCornerRadius = 0;
        _categoryView.indicators = @[indicator];
    }
    return _categoryView;
}

- (JXCategoryListContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    }
    return _containerView;
}

- (QYZYLiveRankSubViewController *)dayRank {
    if (!_dayRank) {
        _dayRank = [[QYZYLiveRankSubViewController alloc] init];
        _dayRank.anchorId = self.anchorId;
        _dayRank.isDay = YES;
    }
    return _dayRank;
}

- (QYZYLiveRankSubViewController *)weekRank {
    if (!_weekRank) {
        _weekRank = [[QYZYLiveRankSubViewController alloc] init];
        _weekRank.anchorId = self.anchorId;
        _weekRank.isDay = NO;
    }
    return _weekRank;
}

@end
