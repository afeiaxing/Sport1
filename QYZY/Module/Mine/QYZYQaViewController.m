//
//  QYZYQaViewController.m
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import "QYZYQaViewController.h"
#import "QYZYQaModel.h"
#import "QYZYQATableViewCell.h"
#import "QYZYQaSectionView.h"
#import "NSString+XMAdd.h"


@interface QYZYQaViewController ()<JXCategoryListContentViewDelegate,UITableViewDelegate,UITableViewDataSource,QYZYQaSectionViewDelegate>
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation QYZYQaViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{

  self.tabBarController.tabBar.hidden = NO;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"常见问题";
    [self handleNavBar];
}

#pragma mark - Private Methods
- (void)handleNavBar
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(ScreenHeight);
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    QYZYQaModel *sectionModel = self.dataSource[section];
    if (sectionModel.isOpen) {
        return sectionModel.answerList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QYZYQaModel *sectionModel = self.dataSource[indexPath.section];
    QYZYQARouModel *rowModel = sectionModel.answerList[indexPath.row];
    
    QYZYQATableViewCell * cell = [[QYZYQATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([QYZYQATableViewCell class]) rowModel:rowModel];
    weakSelf(self)
    cell.clickSpecificationBlock = ^{
//        weakself(self)
//        XMSpecificationViewController *vc = [[XMSpecificationViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QYZYQaModel *sectionModel = self.dataSource[section];
    QYZYQaSectionView *sectionView = [[QYZYQaSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionView.section = section;
    sectionView.delegate = self;
    [sectionView setModel:sectionModel];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - XMCommonProblemSectionViewDelegate
- (void)clickedSection:(QYZYQaSectionView *)sectionView {
    QYZYQaModel *model = self.dataSource[sectionView.section];
    model.isOpen = !model.isOpen;
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:sectionView.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Setter & Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 10;
        _tableView.estimatedSectionHeaderHeight = 50;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[QYZYQATableViewCell class] forCellReuseIdentifier:NSStringFromClass([QYZYQATableViewCell class])];
    }
    return _tableView;
}

- (NSArray *)dataSource {
    if (!_dataSource) {
        NSDictionary *dic = [@"question" xm_readLocalJSONFile];
        NSArray *dataArr = [dic objectForKey:@"data"];
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:dataArr.count];
        [dataArr enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            QYZYQaModel *model = [QYZYQaModel yy_modelWithDictionary:obj];
            [mutableArr addObject:model];
        }];
        _dataSource = [NSArray arrayWithArray:mutableArr];
    }
    return _dataSource;
}


- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    }
    return _lineView;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
