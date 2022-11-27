//
//  QYZYTotalNewsViewController.m
//  QYZY
//
//  Created by jsmaster on 10/1/22.
//

#import "QYZYTotalNewsViewController.h"
#import "QYZYTotalNewsSubViewController.h"
#import "QYZYTotalNewsUtil.h"
#import "QYZYTotalNewsLabelModel.h"

@interface QYZYTotalNewsViewController ()<JXCategoryViewDelegate ,JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *containerView;

@property (nonatomic, strong) NSArray *totalNewsLabels;
@property (nonatomic, strong) NSMutableArray *categoryTitles;
@property (nonatomic, strong) NSMutableArray *childVcArray;

@end

@implementation QYZYTotalNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.totalNewsLabels = [QYZYTotalNewsUtil loadTotalNewsLabelDataSource];
    [self.totalNewsLabels enumerateObjectsUsingBlock:^(QYZYTotalNewsLabelModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QYZYTotalNewsSubViewController *vc = [[QYZYTotalNewsSubViewController alloc] init];
        [self.childVcArray addObject:vc];
        [self.categoryTitles addObject:obj.name];
    }];
    
    [self setupSubViews];
}

- (void)setupSubViews {
    [self.view addSubview:self.categoryView];
    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.categoryView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - delegate
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return categoryView.selectedIndex != index;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.categoryView.titles.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    if (self.childVcArray.count) {
        QYZYTotalNewsSubViewController *vc = self.childVcArray[index];
        vc.model = self.totalNewsLabels[index];
        return vc;
    }
    return (id<JXCategoryListContentViewDelegate>)UIViewController.new;
}

#pragma mark - get
- (NSArray *)totalNewsLabels {
    if (!_totalNewsLabels) {
        _totalNewsLabels = [NSArray array];
    }
    return _totalNewsLabels;
}

- (NSMutableArray *)categoryTitles {
    if (!_categoryTitles) {
        _categoryTitles = [NSMutableArray array];
    }
    return _categoryTitles;
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titles = self.categoryTitles;
        _categoryView.titleColor = rgb(34, 34, 34);
        _categoryView.titleSelectedColor = rgb(41, 69, 192);
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _categoryView.cellWidth = 54;
        _categoryView.cellSpacing = 6;
        _categoryView.delegate = self;
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

- (JXCategoryListContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
        _containerView.listCellBackgroundColor = UIColor.clearColor;
        _containerView.scrollView.backgroundColor = UIColor.clearColor;
    }
    return _containerView;
}

- (NSMutableArray *)childVcArray {
    if (!_childVcArray) {
        _childVcArray = [[NSMutableArray alloc] init];
    }
    return _childVcArray;
}

@end
