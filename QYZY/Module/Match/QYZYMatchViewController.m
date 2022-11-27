//
//  QYZYMatchViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import "QYZYMatchViewController.h"
#import "QYZYSubMainViewController.h"
#import "QYZYMatchCell.h"
#import "FSCalendarView.h"

@interface QYZYMatchViewController ()<JXCategoryViewDelegate,JXCategoryListContainerViewDelegate,FSCalendarDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *containerView;
@property (nonatomic, strong) QYZYSubMainViewController *footVC;
@property (nonatomic, strong) QYZYSubMainViewController *basketVC;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) NSString *currentDateString;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) FSCalendarView *calendarView;
@property (nonatomic, strong) NSDate *calendarDate;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation QYZYMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = rgb(248, 249, 254);
    [self setup];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(timerLoadReData) userInfo:nil repeats:YES];
    }
}

- (void)timerLoadReData {
    self.footVC.currentDateString = self.currentDateString;
    [self.footVC requestData];
    self.basketVC.currentDateString = self.currentDateString;
    [self.basketVC requestData];
}

- (void)setup {
    self.currentDateString = [NSDate getDateStringWithDate:NSDate.date formatter:@"yyyy-MM-dd"];
    self.leftItem = nil;
    self.categoryView.frame = CGRectMake(0, 0, 180, 32);
    self.navigationItem.titleView = self.categoryView;
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.selectButton];
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(62);
        make.right.equalTo(self.view).offset(-4);
        make.bottom.equalTo(self.view).offset(-TabBarHeight - 28);
    }];
}

- (void)selectAction {
    self.bgView.hidden = NO;
    self.calendarView.hidden = NO;
    [UIApplication.sharedApplication.keyWindow addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIApplication.sharedApplication.keyWindow);
    }];
    [self.bgView addSubview:self.calendarView];
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - 32 * 2, 400));
    }];
}

- (void)sureAction {
    if (!self.calendarDate) {
        return;
    }
    NSString *changeString = [NSDate getDateStringWithDate:self.calendarDate formatter:@"yyyy-MM-dd"];
    if ([self.currentDateString isEqualToString:changeString]) return;
    self.currentDateString = changeString;
    self.footVC.currentDateString = self.currentDateString;
    [self.footVC requestData];
    self.basketVC.currentDateString = self.currentDateString;
    [self.basketVC requestData];
}

- (void)cancelAction {
    self.bgView.hidden = YES;
    self.calendarView.hidden = YES;
}

- (void)calendarDidSelectedWithDate:(NSDate *)date {
    self.calendarDate = date;
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
        return self.footVC;
    }
    else {
        return self.basketVC;
    }
}

- (JXCategoryTitleView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleView alloc] init];
        _categoryView.titles = @[@"足球",@"篮球"];
        _categoryView.titleColor = rgb(196, 220, 255);
        _categoryView.titleSelectedColor = rgb(12, 35, 137);
        _categoryView.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        _categoryView.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _categoryView.cellWidth = 87;
        _categoryView.cellSpacing = 0;
        _categoryView.delegate = self;
        _categoryView.listContainer = self.containerView;
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

- (QYZYSubMainViewController *)footVC {
    if (!_footVC) {
        _footVC = [[QYZYSubMainViewController alloc] init];
        _footVC.matchType = QYZYMatchTypeFootball;
        _footVC.currentDateString = self.currentDateString;
    }
    return _footVC;
}

- (QYZYSubMainViewController *)basketVC {
    if (!_basketVC) {
        _basketVC = [[QYZYSubMainViewController alloc] init];
        _basketVC.matchType = QYZYMatchTypeBasketball;
        _basketVC.currentDateString = self.currentDateString;
    }
    return _basketVC;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"match_home_sel"] forState:UIControlStateNormal];
        [_selectButton addTarget:self action:@selector(selectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}

- (FSCalendarView *)calendarView{
    if (!_calendarView) {
        _calendarView = [[FSCalendarView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth - 32 * 2, 400) viewType:FSCalendarViewTypeDefault selectDayLimit:30];
        _calendarView.layer.cornerRadius = 10;
        _calendarView.layer.masksToBounds = YES;
        _calendarView.fsDelegate = self;
        weakSelf(self);
        _calendarView.cancelBlock = ^{
            strongSelf(self);
            [self cancelAction];
        };
        _calendarView.conformBlock = ^{
            strongSelf(self);
            [self sureAction];
            [self cancelAction];
        };
    }
    return _calendarView;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = rgba(0, 0, 0, 0.5);
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
//        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

@end
