//
//  QYZYCommendController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import "QYZYCommendController.h"

@interface QYZYCommendController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QYZYCommendController

#pragma mark - lazy load
- (UIView *)container {
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.backgroundColor = UIColor.whiteColor;
    }
    return _container;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configController];
}

- (void)configController {
    [self.view addSubview:self.container];
    [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(60);
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight-60) byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(12,12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-60);
    maskLayer.path = maskPath.CGPath;
    self.container.layer.mask = maskLayer;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = rgb(216, 216, 216);
    line.layer.cornerRadius = 2;
    [self.container addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(48);
        make.height.mas_offset(4);
        make.top.equalTo(self.container).offset(16);
        make.centerX.equalTo(self.container);
    }];
    
    self.tableView.backgroundColor = UIColor.orangeColor;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(line.mas_bottom);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"");
}


@end
