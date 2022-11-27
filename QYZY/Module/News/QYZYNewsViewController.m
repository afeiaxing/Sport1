//
//  QYZYNewsViewController.m
//  QYZY
//
//  Created by jsmaster on 9/27/22.
//

#import "QYZYNewsViewController.h"
#import "QYZYHotNewsViewController.h"
#import "QYZYTotalNewsViewController.h"

@interface QYZYNewsViewController () <JXCategoryViewDelegate ,JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *containerView;

@end

@implementation QYZYNewsViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupSubViews];
}

- (void)setupSubViews {
    self.view.backgroundColor = rgb(35, 57, 180);
    
    self.categoryView.frame = CGRectMake(0, 0, 180, 32);
    self.navigationItem.titleView = self.categoryView;
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - JXCategoryViewDelegate ,JXCategoryListContainerViewDelegate
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return categoryView.selectedIndex != index;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (index == 0) {
        return [QYZYHotNewsViewController new];
    } else {
        return [QYZYTotalNewsViewController new];
    }
}

#pragma mark - getter & setter
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titles = @[@"热门",@"综合"];
        _categoryView.titleColor = rgb(196, 220, 255);
        _categoryView.titleSelectedColor = UIColor.whiteColor;
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _categoryView.cellWidth = 87;
        _categoryView.cellSpacing = 0;
        _categoryView.delegate = self;
        _categoryView.listContainer = self.containerView;
        _categoryView.titleSelectedColor = rgb(12, 35, 137);
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

@end
