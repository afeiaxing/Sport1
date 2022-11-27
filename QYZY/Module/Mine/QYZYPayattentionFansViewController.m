//
//  QYZYPayattentionFansViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import "QYZYPayattentionFansViewController.h"
#import "QYZYMYFansViewController.h"
#import "QYZYMyattentionViewController.h"

@interface QYZYPayattentionFansViewController ()<JXCategoryViewDelegate ,JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *containerView;
@property (nonatomic, strong) QYZYMYFansViewController *myreservationVC;
@property (nonatomic, strong) QYZYMyattentionViewController *myattentionVC;
@end

@implementation QYZYPayattentionFansViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
  self.tabBarController.tabBar.hidden = NO;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupSubViews {
    [self.view addSubview:self.categoryView];
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
        return self.myattentionVC;
    }
    if (index == 1) {
        return self.myreservationVC;
    }
    return (id<JXCategoryListContentViewDelegate>)UIViewController.new;
}

#pragma mark - get
- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titles = @[@"关注",@"粉丝"];
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

- (QYZYMYFansViewController *)myreservationVC {
    if (!_myreservationVC) {
        _myreservationVC = [[QYZYMYFansViewController alloc] init];
    }
    return _myreservationVC;
}


- (QYZYMyattentionViewController *)myattentionVC
{
    if (!_myattentionVC) {
        _myattentionVC = [[QYZYMyattentionViewController alloc]init];
    }
    return _myattentionVC;
}





@end
