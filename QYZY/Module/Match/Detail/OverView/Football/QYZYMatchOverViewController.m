//
//  QYZYMatchOverViewController.m
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYMatchOverViewController.h"
#import "QYZYMatchOverHeaderView.h"
#import "QYZYMatchOverCell.h"
#import "QYZYMatchOverEventCell.h"
#import "QYZYTableEmptyCell.h"
#import "QYZYMatchViewModel.h"
#import "QYZYMatchOverHelpView.h"

@interface QYZYMatchOverViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong) QYZYMatchOverHeaderView *headerView;
@property (nonatomic ,strong) QYZYMatchViewModel *viewModel;
@property (nonatomic ,strong) NSArray<QYZYMatchOverModel *> *overArray;
@property (nonatomic ,strong) NSArray<QYZYMatchEventModel *> *eventArray;

@property (nonatomic, strong) UIButton *helpBtn;
@property (nonatomic, strong) QYZYMatchOverHelpView *helpView;
@end

@implementation QYZYMatchOverViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYMatchOverCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYMatchOverCell.class)];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYMatchOverEventCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(QYZYMatchOverEventCell.class)];
    [self.tableView registerClass:QYZYTableEmptyCell.class forCellReuseIdentifier:NSStringFromClass(QYZYTableEmptyCell.class)];
    weakSelf(self);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        strongSelf(self);
        [self requestData];
    }];
    
    [self requestData];
    
    [self.view addSubview:self.helpBtn];
    [self.helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-80);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    [self.view addSubview:self.helpView];
    [self.helpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-80-46-10);
        make.width.mas_equalTo(88);
    }];
}

- (void)helpAction:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        _helpView.alpha = .0;
        [UIView animateWithDuration:1.0 animations:^{
            [self.helpView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(212);
            }];
            self.helpView.alpha = 1;
        }];
    }else {
        [UIView animateWithDuration:1.0 animations:^{
            [self.helpView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            self.helpView.alpha = 0;
        }];
    }
}

- (void)setDetailModel:(QYZYMatchMainModel *)detailModel {
    _detailModel = detailModel;
    self.viewModel.isBasket = ![detailModel.sportId isEqualToString:@"1"];
    self.headerView.detailModel = detailModel;
}

- (void)requestData {
    weakSelf(self);
//    [self.viewModel requestMatchOverPhraseWithMatchId:self.matchId completion:^(NSArray<QYZYMatchOverModel *> * _Nonnull overArray) {
//        strongSelf(self);
//        [self.tableView.mj_header endRefreshing];
//        if (overArray && overArray.count) {
//            self.overArray = overArray;
//            [self.tableView reloadData];
//        }
//        else {
//            if (self.overArray.count == 0) {
//                [self requestEventPhraseData];
//            }
//        }
//    }];
    [self.viewModel requestMatchEventWithMatchId:self.matchId completion:^(NSArray<QYZYMatchEventModel *> * _Nonnull eventArray) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        if (eventArray) {
            self.eventArray = eventArray;
            [self.tableView reloadData];
        }
    }];
}

- (void)requestEventPhraseData {
    weakSelf(self);
    [self.viewModel requestMatchOverEventWithMatchId:self.matchId completion:^(NSArray<QYZYMatchOverModel *> * _Nonnull overArray) {
        strongSelf(self);
        [self.tableView.mj_header endRefreshing];
        if (overArray) {
            self.overArray = overArray;
            [self.tableView reloadData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.eventArray.count) {
        QYZYMatchOverEventCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(QYZYMatchOverEventCell.class) forIndexPath:indexPath];
        if (self.eventArray.count > indexPath.row) {
            cell.eventModel = self.eventArray[indexPath.row];
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
    return self.eventArray.count ? self.eventArray.count : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.eventArray.count ? 72 : (self.view.frame.size.height - 60);
}

#pragma mark - get
- (QYZYMatchOverHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[QYZYMatchOverHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
    }
    return _headerView;
}

- (QYZYMatchViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QYZYMatchViewModel alloc] init];
    }
    return _viewModel;
}

- (UIButton *)helpBtn {
    if (!_helpBtn) {
        _helpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpBtn setImage:[UIImage imageNamed:@"match_over_no"] forState:UIControlStateNormal];
        [_helpBtn setImage:[UIImage imageNamed:@"match_over_se"] forState:UIControlStateSelected];
        [_helpBtn addTarget:self action:@selector(helpAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}

- (QYZYMatchOverHelpView *)helpView {
    if (!_helpView) {
        _helpView = [[QYZYMatchOverHelpView alloc] init];
    }
    return _helpView;
}

@end
