//
//  QYZYPlayerDataController.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYPlayerDataController.h"
#import "QYZYPlayersApi.h"
#import "QYZYPlayerDataCell.h"
#import "QYZYPlayerDataHeader.h"
#import "QYZYPlayerDataModel.h"

typedef NS_ENUM(NSInteger, PlayerDataType) {
    PlayerDataTypeHost = 1,         // 主队
    PlayerDataTypeGuest = 2,        // 客队
};

@interface QYZYPlayerDataController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sections;

@property (nonatomic, strong) QYZYPlayerDataModel *hostPlayerModel;

@property (nonatomic, strong) QYZYPlayerDataModel *guestPlayerModel;

@end

@implementation QYZYPlayerDataController

- (UIView *)listView {
    return self.view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupController];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.sections.count == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadData];
        });
    }
}

- (void)setupController {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadData {
    QYZYPlayersApi *api = [QYZYPlayersApi new];
    api.matchId = self.detailModel.matchId;
    weakSelf(self)
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
          strongSelf(self)
        id data = request.responseJSONObject[@"data"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in data) {
                NSDictionary *dict = data[key];
                if (key.integerValue == self.detailModel.hostTeamId.integerValue) {
                    QYZYPlayerDataModel *model = [QYZYPlayerDataModel yy_modelWithJSON:dict];
                    self.hostPlayerModel = model;
                }else if (key.integerValue == self.detailModel.guestTeamId.integerValue) {
                    QYZYPlayerDataModel *model = [QYZYPlayerDataModel yy_modelWithJSON:dict];
                    self.guestPlayerModel = model;
                }
            }
            
            [self sortTableViewCell];
            [self.tableView reloadData];
        }

        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSLog(@"");
    }];
}

#pragma mark - method
- (void)sortTableViewCell {
    [self.sections removeAllObjects];
    CGFloat hostHeight = 0;
    if (self.hostPlayerModel) {
        [self.sections addObject:@(PlayerDataTypeHost)];
        hostHeight = (self.hostPlayerModel.playerStats.count+1)*40 +40;
    }
    
    CGFloat guestHeight = 0;
    if (self.guestPlayerModel) {
        [self.sections addObject:@(PlayerDataTypeGuest)];
        guestHeight = (self.guestPlayerModel.playerStats.count+1)*40 +40;
    }
    
    !self.updateHeightBlock?:self.updateHeightBlock(hostHeight + guestHeight);
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PlayerDataType type = (PlayerDataType)[self.sections[section] integerValue];
    if (type == PlayerDataTypeHost) {
        return 1;
    }else if (type == PlayerDataTypeGuest) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sections.count > indexPath.section) {
        QYZYPlayerDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYPlayerDataCell" forIndexPath:indexPath];
        PlayerDataType type = (PlayerDataType)[self.sections[indexPath.section] integerValue];
        if (type == PlayerDataTypeHost) {
            cell.model = self.hostPlayerModel;
        }else if (type == PlayerDataTypeGuest) {
            cell.model = self.guestPlayerModel;
        }
        return cell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayerDataType type = (PlayerDataType)[self.sections[indexPath.section] integerValue];
    if (type == PlayerDataTypeHost) {
        return (self.hostPlayerModel.playerStats.count + 1)*40;
    }else if (type == PlayerDataTypeGuest){
        return (self.guestPlayerModel.playerStats.count + 1)*40;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QYZYPlayerDataHeader *header =  [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QYZYPlayerDataHeader"];
    if (self.sections.count > section) {
        PlayerDataType type = (PlayerDataType)[self.sections[section] integerValue];
        if (type == PlayerDataTypeHost) {
            header.title = self.detailModel.hostTeamName;
            header.img = self.detailModel.hostTeamLogo;
        }else {
            header.title = self.detailModel.guestTeamName;
            header.img = self.detailModel.guestTeamLogo;
        }
    }
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = rgb(248, 250, 253);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [_tableView registerClass:[QYZYPlayerDataCell class] forCellReuseIdentifier:@"QYZYPlayerDataCell"];
        [_tableView registerClass:[QYZYPlayerDataHeader class] forHeaderFooterViewReuseIdentifier:@"QYZYPlayerDataHeader"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}
- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [[NSMutableArray alloc] init];
    }
    return _sections;
}

@end
