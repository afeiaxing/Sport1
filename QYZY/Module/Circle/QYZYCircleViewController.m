//
//  QYZYCircleViewController.m
//  QYZY
//
//  Created by jsmaster on 9/27/22.
//

#import "QYZYCircleViewController.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryView.h"

#import "QYZYCircleFollowViewController.h"
#import "QYZYHotViewController.h"
#import "QYZYCircleListController.h"
#import "QYZYCircleDetailController.h"
#import "QYZYPersonalhomepageViewController.h"
#import "QYZYLikeApi.h"
#import "QYZYPhoneLoginViewController.h"

@interface QYZYCircleViewController ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *segmentView;

@property (nonatomic, strong) JXCategoryListContainerView *containerView;

@property (nonatomic, strong) UIView *navigationView;

@property (strong, nonatomic) UIView *navigateView;

@property (nonatomic, strong) NSMutableArray *vcArray;

@property (nonatomic, strong) QYZYCircleListController *circleListVc;

@end

@implementation QYZYCircleViewController

#pragma mark - lazy load
- (JXCategoryTitleView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[JXCategoryTitleView alloc] init];
        _segmentView.backgroundColor = rgb(12, 35, 137);
        _segmentView.layer.cornerRadius = 4.0;
        _segmentView.titles = @[@"热门",@"关注",@"圈子"];
        _segmentView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _segmentView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _segmentView.titleColor = rgb(196, 220, 255);
        _segmentView.cellWidth = 270/3.0;
        _segmentView.cellWidthIncrement = 0;
        _segmentView.cellSpacing = 0;
        _segmentView.titleSelectedColor = rgb(41, 69, 192);
        _segmentView.delegate = self;
        
        JXCategoryIndicatorBackgroundView *indicatoView = [[JXCategoryIndicatorBackgroundView alloc] init];
        indicatoView.indicatorCornerRadius = 0;
        indicatoView.indicatorHeight = 28;
        indicatoView.indicatorWidth = 87;
        indicatoView.indicatorWidthIncrement = 0;
        indicatoView.indicatorCornerRadius = 4.f;
        indicatoView.indicatorColor = UIColor.whiteColor;
        _segmentView.indicators = @[indicatoView];
    }
    return _segmentView;
}

- (JXCategoryListContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    }
    return _containerView;
}

- (NSMutableArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [[NSMutableArray alloc] init];
    }
    return _vcArray;
}

- (UIView *)navigateView {
    if (!_navigateView) {
        _navigateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 64)];
    }
    return _navigateView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildVc];
    [self layoutBody];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)layoutBody {
    
    // 这里用masonry让点击效果无效
    self.segmentView.frame = CGRectMake(0, 8, 270, 32);
    [self.navigateView addSubview:self.segmentView];

    self.navigationItem.titleView = self.navigateView;

    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];

    self.segmentView.contentScrollView = self.containerView.scrollView;
}

- (void)addChildVc {
    QYZYHotViewController *hotVc = [[QYZYHotViewController alloc] init];
    weakSelf(self)
    hotVc.goToDetailPageBlock = ^(QYZYCircleContentModel * _Nonnull model) {
        strongSelf(self)
        [self goToDetailPageWithModel:model];
    };
    hotVc.circleTapBlock = ^(QYZYCircleListModel * _Nonnull model) {
      strongSelf(self)
        self.segmentView.defaultSelectedIndex = 2;
        [self.containerView didClickSelectedItemAtIndex:2];
        [self.segmentView reloadData];
        [self.containerView reloadData];
        [self.circleListVc updateSegmentIndexWithModel:model];
    };
    hotVc.personBlock = ^(NSString * _Nonnull userId) {
        strongSelf(self)
        QYZYPersonalhomepageViewController *personalVc = [[QYZYPersonalhomepageViewController alloc] init];
        personalVc.authorId = userId;
        personalVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalVc animated:YES];
    };
    hotVc.likeBlock = ^(QYZYCircleContentModel * _Nonnull model) {
        strongSelf(self)
        if (!QYZYUserManager.shareInstance.isLogin) {
            QYZYPhoneLoginViewController *vc = [[QYZYPhoneLoginViewController alloc] init];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            return;
        }
        [self likeRequestWithModel:model];
    };
    [self.vcArray addObject:hotVc];
    
    QYZYCircleFollowViewController *followVc = [[QYZYCircleFollowViewController alloc] init];
    followVc.goToDetailPageBlock = ^(QYZYCircleContentModel * _Nonnull model) {
        strongSelf(self)
        [self goToDetailPageWithModel:model];
    };
    followVc.personBlock = ^(NSString * _Nonnull userId) {
        strongSelf(self)
        QYZYPersonalhomepageViewController *personalVc = [[QYZYPersonalhomepageViewController alloc] init];
        personalVc.authorId = userId;
        personalVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalVc animated:YES];
    };
    followVc.likeBlock = ^(QYZYCircleContentModel * _Nonnull model) {
        strongSelf(self)
        if (!QYZYUserManager.shareInstance.isLogin) {
            QYZYPhoneLoginViewController *vc = [[QYZYPhoneLoginViewController alloc] init];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            return;
        }
        [self likeRequestWithModel:model];
    };
    [self.vcArray addObject:followVc];
    
    QYZYCircleListController *circleVc = [[QYZYCircleListController alloc] init];
    circleVc.goToDetailPageBlock = ^(QYZYCircleContentModel * _Nonnull model) {
      strongSelf(self)
        [self goToDetailPageWithModel:model];
    };
    circleVc.likeBlock = ^(QYZYCircleContentModel * _Nonnull model) {
        strongSelf(self)
        if (!QYZYUserManager.shareInstance.isLogin) {
            QYZYPhoneLoginViewController *vc = [[QYZYPhoneLoginViewController alloc] init];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
            return;
        }
        [self likeRequestWithModel:model];
    };
    
    circleVc.personBlock = ^(NSString * _Nonnull userId) {
        strongSelf(self)
        QYZYPersonalhomepageViewController *personalVc = [[QYZYPersonalhomepageViewController alloc] init];
        personalVc.authorId = userId;
        personalVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:personalVc animated:YES];
    };
    
    self.circleListVc = circleVc;
    
    [self.vcArray addObject:circleVc];
}

- (void)likeRequestWithModel:(QYZYCircleContentModel *)model {
    QYZYLikeApi *api = [[QYZYLikeApi alloc] init];
    api.Id = model.Id;
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (model.isLike) {
            // 没有取消点赞，后台一分钟缓存
            return;
        }
        else {
            model.isLike = YES;
            int count = (model.likeCount.intValue) + 1;
            model.likeCount = [NSString stringWithFormat:@"%d",count];
            [self.vcArray enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj respondsToSelector:@selector(reloadData)]) {
                    [obj performSelector:@selector(reloadData)];
                }
            }];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    }];
}

#pragma mark - method
- (void)goToDetailPageWithModel:(QYZYCircleContentModel *)model {
    QYZYCircleDetailController *vc = [[QYZYCircleDetailController alloc] init];
    vc.model = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXCategoryViewDelegate && JXCategoryListContainerViewDelegate
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return index != categoryView.selectedIndex;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.containerView didClickSelectedItemAtIndex:index];
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.vcArray.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArray[index];
}

@end
