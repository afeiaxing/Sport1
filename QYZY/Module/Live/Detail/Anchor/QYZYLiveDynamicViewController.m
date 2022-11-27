//
//  QYZYLiveDynamicViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/3.
//

#import "QYZYLiveDynamicViewController.h"
#import "QYZYCircleDetailController.h"
#import "QYZYPersonalhomepageViewController.h"
#import "QYZYCircleCell.h"
#import "QYZYLiveDynamicApi.h"
#import "QYZYTableEmptyCell.h"

@interface QYZYLiveDynamicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) NSArray <QYZYCircleContentModel *> *dyArray;
@end

@implementation QYZYLiveDynamicViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYCircleCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYCircleCell.class)];
    [self.tableView registerClass:QYZYTableEmptyCell.class forCellReuseIdentifier:NSStringFromClass(QYZYTableEmptyCell.class)];
    weakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self);
        if (self.userId) {
            [self requestDynamic];
        }
        else {
            [self.tableView.mj_header endRefreshing];
        }
    }];
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    [self requestDynamic];
}

- (void)requestDynamic {
    QYZYLiveDynamicApi *api = [[QYZYLiveDynamicApi alloc] init];
    api.userId = self.userId;
    weakSelf(self);
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        self.dyArray = [NSArray yy_modelArrayWithClass:QYZYCircleContentModel.class json:request.responseJSONObject[@"data"][@"list"]];
        [self.tableView reloadData];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dyArray.count) {
        QYZYCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYCircleCell.class) forIndexPath:indexPath];
        if (self.dyArray.count > indexPath.row) {
            cell.model = self.dyArray[indexPath.row];
            cell.avatarTapBlock = ^(NSString * _Nonnull userId) {
                QYZYPersonalhomepageViewController *personalVc = [[QYZYPersonalhomepageViewController alloc] init];
                personalVc.authorId = userId;
                personalVc.hidesBottomBarWhenPushed = YES;
                [UIViewController.currentViewController.navigationController pushViewController:personalVc animated:YES];
            };
        }
        return cell;
    }
    else {
        QYZYTableEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYTableEmptyCell.class) forIndexPath:indexPath];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dyArray.count ? self.dyArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dyArray.count ? UITableViewAutomaticDimension : self.view.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dyArray.count) {
        QYZYCircleDetailController *vc = [[QYZYCircleDetailController alloc] init];
        vc.model = self.dyArray[indexPath.row];
        vc.hidesBottomBarWhenPushed = YES;
        [UIViewController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}

@end
