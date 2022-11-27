//
//  QYZYTeamDataViewController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYTeamDataViewController.h"
#import "QYZYTeamNameCell.h"
#import "QYZYTeamDataStaticsCell.h"
#import "QYZYBasketballTeamStatApi.h"
#import "QYZYTeamStaticsModel.h"
#import "QYZYTeamStaticShowupModel.h"
#import "QYZYTableEmptyCell.h"

@interface QYZYTeamDataViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation QYZYTeamDataViewController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubViews];
    [self loadData];
}

- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.datas.count > 0) {
        return self.datas.count + 1;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QYZYTeamNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYTeamNameCell" forIndexPath:indexPath];
        cell.detailModel = self.detailModel;
        return cell;
    }else {
        if (self.datas.count == 0) {
            QYZYTableEmptyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYTableEmptyCell" forIndexPath:indexPath];
            return cell;
        }else {
            QYZYTeamDataStaticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYTeamDataStaticsCell" forIndexPath:indexPath];
            cell.indexPath = indexPath;
            QYZYTeamStaticShowupModel *model = self.datas[indexPath.row - 1];
            cell.model = model;
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 35;
    }else {
        if (self.datas.count == 0) {
            return 350;
        }
    }
    return 50;
}

#pragma mark - method
- (void)handleData:(QYZYTeamStaticsModel *)teamStasticsModel {
    [self.datas removeAllObjects];
    // 投篮
    if (teamStasticsModel.hostThrow.length || teamStasticsModel.guestThrow.length) {
        QYZYTeamStaticShowupModel *model = [QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostThrow guestTeamValue:teamStasticsModel.guestThrow itemNameValue:@"投篮"];
        [self.datas addObject:model];
    }
    
    //  投篮命中
    if (teamStasticsModel.hostThrowPoint.length || teamStasticsModel.guestThrowPoint.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostThrowPoint guestTeamValue:teamStasticsModel.guestThrowPoint itemNameValue:@"投篮命中"]];
    }

    //  三分
    if (teamStasticsModel.hostThrPnt.length || teamStasticsModel.guestThrPnt.length) {
        QYZYTeamStaticShowupModel *threeViewModel = [QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostThrPnt guestTeamValue:teamStasticsModel.guestThrPnt itemNameValue:@"三分"];
        [self.datas addObject:threeViewModel];
    }
    
    // 三分命中
    if (teamStasticsModel.hostThrPntMade.length || teamStasticsModel.guestThrPntMade.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostThrPntMade guestTeamValue:teamStasticsModel.guestThrPntMade itemNameValue:@"三分命中"]];
    }

    // 罚球
    if (teamStasticsModel.hostPnlty.length || teamStasticsModel.guestPnlty.length) {
        QYZYTeamStaticShowupModel *pnltyViewModel = [QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostPnlty guestTeamValue:teamStasticsModel.guestPnlty itemNameValue:@"罚球"];
        [self.datas addObject:pnltyViewModel];
    }
    
    // 罚球命中
    if (teamStasticsModel.hostPnltyPoint.length || teamStasticsModel.guestPnltyPoint.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostPnltyPoint guestTeamValue:teamStasticsModel.guestPnltyPoint itemNameValue:@"罚球命中"]];
    }
    
    // 篮板
    if (teamStasticsModel.hostRbnd.length || teamStasticsModel.guestRbnd.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostRbnd guestTeamValue:teamStasticsModel.guestRbnd itemNameValue:@"篮板"]];
    }
    
    // 进攻篮板
    if (teamStasticsModel.hostOffensiveRebound.length || teamStasticsModel.guestOffensiveRebound.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostOffensiveRebound guestTeamValue:teamStasticsModel.guestOffensiveRebound itemNameValue:@"进攻篮板"]];
    }
    
    // 防守篮板
    if (teamStasticsModel.hostDefensiveRebound.length || teamStasticsModel.guestDefensiveRebound.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostDefensiveRebound guestTeamValue:teamStasticsModel.guestDefensiveRebound itemNameValue:@"防守篮板"]];
    }

    // 助攻
    if (teamStasticsModel.hostAssist.length || teamStasticsModel.guestAssist.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostAssist guestTeamValue:teamStasticsModel.guestAssist itemNameValue:@"助攻"]];
    }
    
    // 抢断
    if (teamStasticsModel.hostSteal.length || teamStasticsModel.guestSteal.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostSteal guestTeamValue:teamStasticsModel.guestSteal itemNameValue:@"抢断"]];
    }
    
    // 盖帽
    if (teamStasticsModel.hostBlckSht.length || teamStasticsModel.guestBlckSht.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostBlckSht guestTeamValue:teamStasticsModel.guestBlckSht itemNameValue:@"盖帽"]];
    }
    
    // 失误
    if (teamStasticsModel.hostTurnover.length || teamStasticsModel.guestTurnover.length) {
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:teamStasticsModel.hostTurnover guestTeamValue:teamStasticsModel.guestTurnover itemNameValue:@"失误"]];
    }
    
    // 控球时间
    if (teamStasticsModel.hostPossessionRate.length || teamStasticsModel.guestPossessionRate.length) {

        teamStasticsModel.hostPossessionRate = [QYZYTeamDataViewController showMatchNumWithMatchNumString:teamStasticsModel.hostPossessionRate];
        teamStasticsModel.guestPossessionRate = [QYZYTeamDataViewController showMatchNumWithMatchNumString:teamStasticsModel.guestPossessionRate];
        [self.datas addObject:[QYZYTeamStaticShowupModel configWithHostTeamValue:[teamStasticsModel.hostPossessionRate xm_onlyAddPerCent] guestTeamValue:[teamStasticsModel.guestPossessionRate xm_onlyAddPerCent] itemNameValue:@"控球时间"]];
    }

    if (self.datas.count == 0) {
        !self.updateHeightBlock?:self.updateHeightBlock(350);
    }else {
        CGFloat height = self.datas.count *50 +35;
        !self.updateHeightBlock?:self.updateHeightBlock(height);
    }
    [self.tableView reloadData];
}

+ (NSString *)showMatchNumWithMatchNumString:(NSString *)numString {
    if (!numString.length) {
        numString = @"0";
    }
    return numString;
}


#pragma mark - request
- (void)loadData {
    QYZYBasketballTeamStatApi *api = [QYZYBasketballTeamStatApi new];
    api.matchId = self.detailModel.matchId;
    
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            strongSelf(self)
        QYZYTeamStaticsModel *model = [QYZYTeamStaticsModel yy_modelWithJSON:request.responseJSONObject[@"data"]];
        [self handleData:model];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[QYZYTeamNameCell class] forCellReuseIdentifier:@"QYZYTeamNameCell"];
        [_tableView registerClass:[QYZYTeamDataStaticsCell class] forCellReuseIdentifier:@"QYZYTeamDataStaticsCell"];
        [_tableView registerClass:[QYZYTableEmptyCell class] forCellReuseIdentifier:@"QYZYTableEmptyCell"];
    }
    return _tableView;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [[NSMutableArray alloc] init];
    }
    return _datas;
}

- (void)setDetailModel:(QYZYMatchMainModel *)detailModel {
    _detailModel = detailModel;
    [self.tableView reloadData];
}

@end
