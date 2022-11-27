//
//  QYZYRankViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import "QYZYRankViewController.h"
#import "QYZYPopularListViewController.h"
#import "QYZYHeroismListViewController.h"

@interface QYZYRankViewController ()<JXCategoryViewDelegate ,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *containerView;
@property (nonatomic, strong) QYZYPopularListViewController *popularListVC;
@property (nonatomic, strong) QYZYHeroismListViewController *heroismListVC;
@end

@implementation QYZYRankViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    self.view.backgroundColor = [UIColor whiteColor];
    

}

- (void)setupSubViews {
    
    self.categoryView.frame = CGRectMake(0, 0, 220, 44);
    self.navigationItem.titleView = self.categoryView;

    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)click:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
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
        return self.popularListVC;
    }
    if (index == 1) {
        return self.heroismListVC;
    }
    return (id<JXCategoryListContentViewDelegate>)UIViewController.new;
}

#pragma mark - get
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titles = @[@"主播人气榜",@"达人豪气榜"];
        _categoryView.titleColor = rgb(196, 220, 255);
        _categoryView.titleSelectedColor = UIColor.whiteColor;
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _categoryView.cellWidth = 60;
        _categoryView.cellSpacing = 31;
        _categoryView.delegate = self;
        _categoryView.listContainer = self.containerView;
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

- (QYZYPopularListViewController *)popularListVC
{
    if (!_popularListVC) {
        _popularListVC = [[QYZYPopularListViewController alloc]init];
    }
    return _popularListVC;
}

- (QYZYHeroismListViewController *)heroismListVC
{
    if (!_heroismListVC) {
        _heroismListVC = [[QYZYHeroismListViewController alloc]init];
    }
    return _heroismListVC;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
