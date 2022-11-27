//
//  QYZYCircleListController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import "QYZYCircleListController.h"
#import "QYZYCircleListApi.h"
#import "QYZYCircleListModel.h"
#import "QYZYCircleChildrenController.h"

@interface QYZYCircleListController ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *segmentView;

@property (nonatomic, strong) JXCategoryListContainerView *containerView;

@property (weak, nonatomic) IBOutlet UIView *segmentContainer;

@property (nonatomic, strong) NSMutableArray *titleModels;

@property (nonatomic, strong) NSMutableArray *titles;

@property (nonatomic, strong) NSMutableArray *vcArray;

@property (nonatomic, strong) QYZYCircleListModel *jumpModel;

@end

@implementation QYZYCircleListController

- (void)reloadData {
    [self.vcArray enumerateObjectsUsingBlock:^(QYZYCircleChildrenController *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj reloadData];
    }];
}

#pragma mark - lazy load
- (JXCategoryTitleView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[JXCategoryTitleView alloc] init];
        _segmentView.titles = self.titles;
        _segmentView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _segmentView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        _segmentView.titleColor = rgb(34, 34, 34);
        _segmentView.cellWidthIncrement = 20;
        _segmentView.cellSpacing = 0;
        _segmentView.titleSelectedColor = rgb(41, 69, 192);
        _segmentView.delegate = self;
        
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorWidth = 15;
        lineView.indicatorColor = rgb(41, 69, 192);
        _segmentView.indicators = @[lineView];
    }
    return _segmentView;
}

- (JXCategoryListContainerView *)containerView {
    if (!_containerView) {
        _containerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_CollectionView delegate:self];
    }
    return _containerView;
}

- (NSMutableArray *)titleModels {
    if (!_titleModels) {
        _titleModels = [[NSMutableArray alloc] init];
    }
    return _titleModels;
}

- (NSMutableArray *)titles {
    if (!_titles) {
        _titles = [[NSMutableArray alloc] init];
    }
    return _titles;
}

- (NSMutableArray *)vcArray {
    if (!_vcArray) {
        _vcArray = [[NSMutableArray alloc] init];
    }
    return _vcArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCircleList];
}

- (UIView *)listView {
    return self.view;
}

- (void)listDidAppear {
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)layoutBody {
    
    [self.segmentContainer addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.segmentContainer);
    }];
    
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.segmentContainer.mas_bottom);
    }];
    
    self.segmentView.contentScrollView = self.containerView.scrollView;
    
    [self.segmentView reloadData];
    [self.containerView reloadData];
}


- (void)addChildVcWithDefaultIndex:(NSInteger)index {
    
    [self.titleModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QYZYCircleListModel *model = obj;
        QYZYCircleChildrenController *vc = [[QYZYCircleChildrenController alloc] initWithModel:model];
        weakSelf(self)
        vc.goToDetailPageBlock = ^(QYZYCircleContentModel * _Nonnull model) {
            strongSelf(self)
            !self.goToDetailPageBlock?:self.goToDetailPageBlock(model);
        };
        vc.personBlock = ^(NSString * _Nonnull userId) {
          strongSelf(self)
            !self.personBlock?:self.personBlock(userId);
        };
        vc.likeBlock = ^(QYZYCircleContentModel * _Nonnull model) {
            !self.likeBlock?:self.likeBlock(model);
        };
        [self.vcArray addObject:vc];
    }];
    
    self.segmentView.defaultSelectedIndex = index;
    [self.containerView didClickSelectedItemAtIndex:index];
    [self.segmentView reloadData];
    [self.containerView reloadData];
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

#pragma mark - request
- (void)getCircleList {
    QYZYCircleListApi *api = [QYZYCircleListApi new];
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self)
        id data = request.responseObject;
        if ([data isKindOfClass:[NSDictionary class]]) {
            id array = [data valueForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]]) {
                NSArray *models = [NSArray yy_modelArrayWithClass:[QYZYCircleListModel class] json:array];
                self.titleModels = models.mutableCopy;
                __block NSInteger defaultIndex = 0;
                [self.titleModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    QYZYCircleListModel *model = obj;
                    [self.titles addObject:model.circleName];
                    
                    if (model.Id.integerValue == self.jumpModel.Id.integerValue) {
                        defaultIndex = idx;
                    }
                }];
                                
                [self addChildVcWithDefaultIndex:defaultIndex];
                [self layoutBody];
            }
        }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
    }];
}

- (void)updateSegmentIndexWithModel:(QYZYCircleListModel *)model {
    if (self.titleModels.count == 0) {
        self.jumpModel = model;
    }else {
        __block NSInteger index = 0;
        [self.titleModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QYZYCircleListModel *listModel = obj;
            if (listModel.Id.integerValue == model.Id.integerValue) {
                index = idx;
            }
        }];
        
        self.segmentView.defaultSelectedIndex = index;
        [self.containerView didClickSelectedItemAtIndex:index];
        [self.segmentView reloadData];
        [self.containerView reloadData];
    }
}

@end
