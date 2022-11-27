//
//  QYZYPlayerDataCell.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYPlayerDataCell.h"
#import "QYZYPlayerDataCollectionCell.h"
#import "QYZYPlayerDataHeaderCell.h"
#import "QYZYPlayerTitleCell.h"

@interface QYZYPlayerDataCell ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *widthArr;

@end

@implementation QYZYPlayerDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.collectionView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.width.mas_offset(122);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.tableView.mas_right);
    }];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QYZYPlayerTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYPlayerTitleCell" forIndexPath:indexPath];
        cell.backgroundColor = rgb(246, 247, 249);
        return cell;
    }else {
        QYZYPlayerDataHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QYZYPlayerDataHeaderCell" forIndexPath:indexPath];
        cell.model = self.model.playerStats[indexPath.row - 1];
        if (indexPath.row %2 == 0) {
            cell.backgroundColor = rgb(246, 247, 249);
        }else {
            cell.backgroundColor = UIColor.whiteColor;
        }
        return cell;
    }
    return [UITableViewCell new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.playerStats.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 36;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
   return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QYZYPlayerDataCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QYZYPlayerDataCollectionCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.title = self.titleArray[indexPath.section];
    cell.model = self.model;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
   return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

   return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake([self.widthArr[indexPath.section] floatValue], collectionView.bounds.size.height);
}


#pragma mark - getter
- (UICollectionView *)collectionView {
   if (!_collectionView) {
       _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.layout];
       _collectionView.backgroundColor = UIColor.clearColor;
       _collectionView.dataSource = self;
       _collectionView.delegate = self;
       _collectionView.showsVerticalScrollIndicator = NO;
       _collectionView.showsHorizontalScrollIndicator = NO;
       _collectionView.scrollEnabled = YES;
       [_collectionView registerClass:[QYZYPlayerDataCollectionCell class]
           forCellWithReuseIdentifier:
        @"QYZYPlayerDataCollectionCell"];
   }
   return _collectionView;
}

- (UICollectionViewFlowLayout *)layout {
   if (!_layout) {
       _layout = [UICollectionViewFlowLayout new];
       _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
   }
   return _layout;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        _tableView.bounces = NO;
        [_tableView registerClass:[QYZYPlayerDataHeaderCell class] forCellReuseIdentifier:@"QYZYPlayerDataHeaderCell"];
        [_tableView registerClass:[QYZYPlayerTitleCell class] forCellReuseIdentifier:@"QYZYPlayerTitleCell"];
    }
    return _tableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"首发",@"时间",@"得分",@"篮板",@"助攻",@"投篮",@"三分",@"罚球",@"抢断",@"盖帽",@"犯规",@"失误"];
    }
    return _titleArray;
}

- (NSArray *)widthArr {
    if (!_widthArr) {
        _widthArr = @[@(30),@(30),@(30),@(30),@(30),@(30),@(30),@(30),@(30),@(30),@(30),@(30)];
    }
    return _widthArr;
}


- (void)setModel:(QYZYPlayerDataModel *)model {
    _model = model;
    [self.tableView reloadData];
    [self.collectionView reloadData];
}

@end
