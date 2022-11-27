//
//  QYZYBasketballScoreView.m
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import "QYZYBasketballScoreView.h"
#import "QYZYScoreCollectionViewCell.h"

@interface QYZYBasketballScoreView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation QYZYBasketballScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.bottomLine];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_offset(10);
    }];
    
    [self addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_offset(0.5);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.mas_bottom);
        make.bottom.equalTo(self.bottomLine.mas_top);
        make.left.right.equalTo(self);
    }];
}

#pragma mark - UICollectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QYZYScoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QYZYScoreCollectionViewCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.periodModel = self.periodModel;
    cell.detailModel = self.detailModel;
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return CGSizeMake(133, collectionView.bounds.size.height);
    }else {
        CGFloat width = (ScreenWidth - 133)/5.0;
        return CGSizeMake(width, collectionView.bounds.size.height);
    }
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = rgb(248, 249, 254);
    }
    return _bottomLine;
}

- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = rgba(0, 0, 0, 0.1);
    }
    return _topLine;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.layout];
//        _collectionView.backgroundColor = XM_RGBColor(255, 255, 255);
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[QYZYScoreCollectionViewCell class]
            forCellWithReuseIdentifier:@"QYZYScoreCollectionViewCell"];
        _collectionView.backgroundColor = UIColor.clearColor;
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

- (void)setPeriodModel:(QYZYPeriodModel *)periodModel {
    _periodModel = periodModel;
    [self.collectionView reloadData];
}

@end
