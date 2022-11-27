//
//  QYZYMatchSubViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/12.
//

#import "QYZYMatchSubViewController.h"
#import "QYZYMatchDetailViewController.h"
#import "QYZYMatchHomeCell.h"
#import "QYZYTableEmptyCell.h"

@interface QYZYMatchSubViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation QYZYMatchSubViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weakSelf(self);
    self.tableView.backgroundColor = rgb(248, 249, 254);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self);
        !self.requestBlock ? : self.requestBlock();
    }];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYMatchHomeCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYMatchHomeCell.class)];
    [self.tableView registerClass:QYZYTableEmptyCell.class forCellReuseIdentifier:NSStringFromClass(QYZYTableEmptyCell.class)];
}

- (void)setMatches:(NSArray *)matches {
    _matches = matches;
    [self.tableView reloadData];
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.matches.count) {
        QYZYMatchHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYMatchHomeCell.class) forIndexPath:indexPath];
        if (self.matches.count > indexPath.row) {
            cell.detailModel = self.matches[indexPath.row];
        }
        return cell;
    }
    else {
        QYZYTableEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYTableEmptyCell.class) forIndexPath:indexPath];
        cell.contentView.backgroundColor = UIColor.whiteColor;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matches.count ? self.matches.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.matches.count ? 82 : self.view.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.matches.count) {
        QYZYMatchDetailViewController *vc = [[QYZYMatchDetailViewController alloc] init];
        vc.matchId = self.matches[indexPath.row].matchId;
        vc.hidesBottomBarWhenPushed = YES;
        [UIViewController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}

@end
