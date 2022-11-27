//
//  QYZYReportView.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import "QYZYReportView.h"
#import "QYZYReportContentCell.h"

@interface QYZYReportView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) CGFloat safeArea;

@end

@implementation QYZYReportView

- (instancetype)initWithSafeArea:(CGFloat)safeArea {
    self = [super init];
    if (self) {
        self.safeArea = safeArea;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeViewFromSuperView)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)showView {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
    
    [self addSubview:self.containerView];
    NSArray *arr = self.dataArray.firstObject;
    
    self.containerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 55*(arr.count + 1)+ 12 + self.safeArea);
    
    [self.containerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    [self animation];
    
}

- (void)animation {
    NSArray *arr = self.dataArray.firstObject;
    NSInteger count = arr.count + 1;
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        self.containerView.frame = CGRectMake(0, ScreenHeight - (55*count + 12 + self.safeArea), ScreenWidth, 55*count + 12 + self.safeArea);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)removeViewFromSuperView {
    [UIView animateWithDuration:0.35f animations:^{
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.containerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 55*4 + 12 + self.safeArea);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subArr = self.dataArray[section];
    return subArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYReportContentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QYZYReportContentCell class]) forIndexPath:indexPath];
    NSArray *subArr = self.dataArray[indexPath.section];
    cell.title = subArr[indexPath.row];
    if (indexPath.section > 0) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    
//    if (self.selectIndex == indexPath.row && indexPath.section == 0) {
//        cell.titleLabel.textColor = RGBAlpha(245, 140, 68,1);
//    }else {
//        cell.titleLabel.textColor = RGBAlpha(51, 51, 51,1);
//    }
//
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.groupTableViewBackgroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 12;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        !self.actionBlock?:self.actionBlock(indexPath.row);
    }
    [self removeViewFromSuperView];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self) {
        return YES;
    }
    return NO;
}

#pragma mark - getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UIColor.whiteColor;
    }
    return _containerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[QYZYReportContentCell class] forCellReuseIdentifier:NSStringFromClass([QYZYReportContentCell class])];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}


@end
