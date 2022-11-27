//
//  QYZYSituationFooterView.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYSituationFooterView.h"
#import "JXCategoryTitleView.h"
#import "QYZYTeamDataViewController.h"
#import "QYZYPlayerDataController.h"

@interface QYZYSituationFooterView ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *segmentView;

@property (nonatomic, strong) JXCategoryListContainerView *containerView;

@property (nonatomic, strong) NSMutableArray *vcArray;

@property (nonatomic, strong) UIView *segmentContainer;

@property (nonatomic, strong) QYZYTeamDataViewController *teamDataVc;

@property (nonatomic, strong) QYZYPlayerDataController *playerVc;

@property (nonatomic, assign) CGFloat teamFooterHeight;

@property (nonatomic, assign) CGFloat playerFooterHeight;

@end

@implementation QYZYSituationFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addChildContrller];
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    [self addSubview:self.segmentContainer];
    [self.segmentContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_offset(50);
    }];
    
    [self.segmentContainer addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.segmentContainer);
        make.width.mas_offset(200);
        make.height.mas_offset(38);
    }];
    
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentContainer.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
    self.segmentView.contentScrollView = self.containerView.scrollView;
}

- (void)addChildContrller {
    QYZYTeamDataViewController *teamDataVc = [[QYZYTeamDataViewController alloc] init];
    self.teamDataVc = teamDataVc;
    weakSelf(self)
    teamDataVc.updateHeightBlock = ^(CGFloat height) {
        strongSelf(self)
        if (self.segmentView.selectedIndex == 0) {
            CGFloat final = height + 50;
            self.teamFooterHeight = final;
            !self.updateFooterHeightBlock?:self.updateFooterHeightBlock(final);
        }
    };
    [self.vcArray addObject:teamDataVc];
    
    QYZYPlayerDataController *playerDataVc = [[QYZYPlayerDataController alloc] init];
    self.playerVc = playerDataVc;
    [self.vcArray addObject:playerDataVc];
    
    playerDataVc.updateHeightBlock = ^(CGFloat height) {
      strongSelf(self)
        CGFloat final = height + 50;
        self.playerFooterHeight = final;
        !self.updateFooterHeightBlock?:self.updateFooterHeightBlock(final);
    };
}

- (void)reloadData {
    if (self.segmentView.selectedIndex == 0) {
        [self.teamDataVc loadData];
    }else {
        [self.playerVc loadData];
    }
}

#pragma mark - JXCategoryViewDelegate && JXCategoryListContainerViewDelegate
- (BOOL)categoryView:(JXCategoryBaseView *)categoryView canClickItemAtIndex:(NSInteger)index {
    return index != categoryView.selectedIndex;
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    [self.containerView didClickSelectedItemAtIndex:index];
    CGFloat height = index == 0? self.teamFooterHeight:self.playerFooterHeight;
    if (height != 0) {
        !self.updateFooterHeightBlock?:self.updateFooterHeightBlock(height);
    }
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.vcArray.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    return self.vcArray[index];
}

- (JXCategoryTitleView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[JXCategoryTitleView alloc] init];
        _segmentView.backgroundColor = rgb(248, 249, 254);
        _segmentView.layer.cornerRadius = 20;
        _segmentView.titles = @[@"球队数据",@"球员数据"];
        _segmentView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:13];
        _segmentView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _segmentView.titleColor = rgb(149, 157, 176);
        _segmentView.cellWidth = 200/2.0;
        _segmentView.cellWidthIncrement = 0;
        _segmentView.cellSpacing = 0;
        _segmentView.titleSelectedColor = UIColor.whiteColor;
        _segmentView.delegate = self;
        
        JXCategoryIndicatorBackgroundView *indicatoView = [[JXCategoryIndicatorBackgroundView alloc] init];
        indicatoView.indicatorCornerRadius = 0;
        indicatoView.indicatorHeight = 32;
        indicatoView.indicatorWidth = 90;
        indicatoView.indicatorWidthIncrement = 0;
        indicatoView.indicatorCornerRadius = 32/2.0;
        indicatoView.indicatorColor = rgb(41, 69, 192);
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

- (UIView *)segmentContainer {
    if (!_segmentContainer) {
        _segmentContainer = [[UIView alloc] init];
        _segmentContainer.backgroundColor = UIColor.whiteColor;
    }
    return _segmentContainer;
}

- (void)setDetailModel:(QYZYMatchMainModel *)detailModel {
    _detailModel = detailModel;
    self.teamDataVc.detailModel = detailModel;
    self.playerVc.detailModel = detailModel;
}

@end
