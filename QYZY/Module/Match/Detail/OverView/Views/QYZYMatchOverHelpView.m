//
//  QYZYMatchOverHelpView.m
//  QYZY
//
//  Created by jsgordong on 2022/10/25.
//

#import "QYZYMatchOverHelpView.h"
#import "QYZYMatchOverHelpCell.h"

@interface QYZYMatchOverHelpView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;
@end

@implementation QYZYMatchOverHelpView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        
        self.datas = @[
        @{@"icon":@"match_over_goal",@"title":@"进球"},
        @{@"icon":@"match_over_goal",@"title":@"点球"},
        @{@"icon":@"match_over_ss",@"title":@"点球射失"},
        @{@"icon":@"match_over_wu",@"title":@"乌龙球"},
        @{@"icon":@"match_over_yellow",@"title":@"黄牌"},
        @{@"icon":@"match_over_red",@"title":@"红牌"},
        @{@"icon":@"match_over_change",@"title":@"换人"}
        ];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYMatchOverHelpCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYMatchOverHelpCell.class) forIndexPath:indexPath];
    cell.dict = self.datas[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];        
         [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYMatchOverHelpCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYMatchOverHelpCell.class)];

        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    return _tableView;
}

@end
