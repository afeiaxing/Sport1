//
//  QYZYLiveAnchorViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "QYZYLiveAnchorViewController.h"
#import "QYZYLiveAnchorHeaderView.h"

#import "QYZYLiveDynamicViewController.h"
#import "QYZYLiveNoticeViewController.h"

@interface QYZYLiveAnchorViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate>
@property (nonatomic ,strong) JXCategoryTitleView *categoryView;
@property (nonatomic ,strong) JXCategoryListContainerView *containerView;
@property (nonatomic ,strong) QYZYLiveAnchorHeaderView *headerView;
@property (nonatomic ,strong) QYZYLiveDynamicViewController *dynamicVC;
@property (nonatomic ,strong) QYZYLiveNoticeViewController *noticeVC;
@end

@implementation QYZYLiveAnchorViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setsubView];
}

- (void)setsubView {
//    [self.view addSubview:self.headerView];
//    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.top.equalTo(self.view);
//        make.height.mas_equalTo(130);
//    }];
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(140, 30));
        make.top.equalTo(self.view).offset(12);
    }];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom).offset(12);
    }];
}

- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return categoryView.selectedIndex != index;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return self.dynamicVC;
    }
    else {
        return self.noticeVC;
    }
}

- (void)setDetailModel:(QYZYLiveDetailModel *)detailModel {
    _detailModel = detailModel;
    self.headerView.detailModel = detailModel;
    self.dynamicVC.userId = detailModel.userId;
}

- (QYZYLiveAnchorHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(QYZYLiveAnchorHeaderView.class) owner:self options:nil].firstObject;
    }
    return _headerView;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.layer.cornerRadius = 15;
        _categoryView.layer.masksToBounds = YES;
        _categoryView.layer.borderColor = rgb(41, 69, 192).CGColor;
        _categoryView.layer.borderWidth = 1;
        _categoryView.titles = @[@"动态",@"预告"];
        _categoryView.titleColor = rgb(34, 34, 34);
        _categoryView.titleSelectedColor = UIColor.whiteColor;
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _categoryView.cellWidth = 70;
        _categoryView.cellSpacing = 0;
        _categoryView.listContainer = self.containerView;
        _categoryView.delegate = self;
        
        JXCategoryIndicatorBackgroundView *indicator = [[JXCategoryIndicatorBackgroundView alloc] init];
        indicator.indicatorColor = rgb(41, 69, 192);
        indicator.indicatorWidth = 70;
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

- (QYZYLiveDynamicViewController *)dynamicVC {
    if (!_dynamicVC) {
        _dynamicVC = [[QYZYLiveDynamicViewController alloc] init];
    }
    return _dynamicVC;
}

- (QYZYLiveNoticeViewController *)noticeVC {
    if (!_noticeVC) {
        _noticeVC = [[QYZYLiveNoticeViewController alloc] init];
        _noticeVC.anchorId = self.anchorId;
    }
    return _noticeVC;
}

@end
