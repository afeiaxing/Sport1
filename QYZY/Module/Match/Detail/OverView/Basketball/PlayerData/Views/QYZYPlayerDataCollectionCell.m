//
//  QYZYPlayerDataCollectionCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/25.
//

#import "QYZYPlayerDataCollectionCell.h"
#import "QYZYPlayerContentCell.h"

@interface QYZYPlayerDataCollectionCell ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation QYZYPlayerDataCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.playerStats.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QYZYPlayerContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYPlayerContentCell" forIndexPath:indexPath];
    cell.title = self.title;
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = rgb(246, 247, 249);
    }else {
        cell.backgroundColor = UIColor.whiteColor;
    }
    
    if (self.datas.count > indexPath.row - 1) {
        cell.content = self.datas[indexPath.row - 1];
    }
    
    cell.indexPath = indexPath;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 36;
    }
    return 40;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.bounces = NO;
        [_tableView registerClass:[QYZYPlayerContentCell class] forCellReuseIdentifier:@"QYZYPlayerContentCell"];
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)setModel:(QYZYPlayerDataModel *)model {
    _model = model;
    
    [self.datas removeAllObjects];
    if (self.indexPath.section == 0) {// 首发
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.start == 1) {
                [self.datas addObject:@"是"];
            }else {
                [self.datas addObject:@"否"];
            }
        }];
    }else if (self.indexPath.section == 1) {// 时间
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *playTime = [NSString stringWithFormat:@"%zd\'",obj.playTime];
            [self.datas addObject:playTime];
        }];
    }else if (self.indexPath.section == 2) {// 得分
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *point = [NSString stringWithFormat:@"%zd",obj.point];
            [self.datas addObject:point];
        }];
    }else if (self.indexPath.section == 3) {// 篮板
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *rebound = [NSString stringWithFormat:@"%zd",obj.rebound];
            [self.datas addObject:rebound];
        }];
    }else if (self.indexPath.section == 4) {// 助攻
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *assist = [NSString stringWithFormat:@"%zd",obj.assist];
            [self.datas addObject:assist];
        }];
    }else if (self.indexPath.section == 5) {// 投篮
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *fieldGoal = [NSString stringWithFormat:@"%zd/%zd",obj.fieldGoalMade,obj.fieldGoalAttempted];
            [self.datas addObject:fieldGoal];
        }];
    }else if (self.indexPath.section == 6) {// 三分
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *threePoint = [NSString stringWithFormat:@"%zd/%zd",obj.threePointMade,obj.threePointAttempted];
            [self.datas addObject:threePoint];
        }];
    }else if (self.indexPath.section == 7) {// 罚球
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *threePoint = [NSString stringWithFormat:@"%zd/%zd",obj.freeThrowMade,obj.freeThrowAttempted];
            [self.datas addObject:threePoint];
        }];
    }else if (self.indexPath.section == 8) {// 抢断
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *steal = [NSString stringWithFormat:@"%zd",obj.steal];
            [self.datas addObject:steal];
        }];
    }else if (self.indexPath.section == 9) {// 盖帽
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *block = [NSString stringWithFormat:@"%zd",obj.block];
            [self.datas addObject:block];
        }];
    }else if (self.indexPath.section == 10) {// 犯规
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *foul = [NSString stringWithFormat:@"%zd",obj.foul];
            [self.datas addObject:foul];
        }];
    }else if (self.indexPath.section == 11) {// 失误
        [model.playerStats enumerateObjectsUsingBlock:^(QYZYPlayerInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *turnover = [NSString stringWithFormat:@"%zd",obj.turnover];
            [self.datas addObject:turnover];
        }];
    }
    
    [self.tableView reloadData];
}

@end
