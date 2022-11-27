//
//  QYZYLiveMainHeaderView.m
//  QYZY
//
//  Created by jspollo on 2022/9/29.
//

#import "QYZYLiveMainHeaderView.h"
#import "QYZYLiveItemView.h"
#import "QYZYLiveMainHeaderCell.h"
#import "QYZYLiveDetailViewController.h"

@interface QYZYLiveMainHeaderView ()<UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic ,strong) SDCycleScrollView *cycleView;

@end

@implementation QYZYLiveMainHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = UIColor.clearColor;
    [self setupSubViews];
}

- (void)setupSubViews {
    [self addSubview:self.cycleView];
    self.titleLabel.textColor = rgb(41, 69, 192);
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    self.moreButton.layer.borderColor = rgb(41, 69, 192).CGColor;
    self.moreButton.layer.borderWidth = 1;
    self.moreButton.layer.cornerRadius = 11;
    [self.moreButton setTitleColor:rgb(41, 69, 192) forState:UIControlStateNormal];
    self.moreButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.moreButton.hidden = YES;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYLiveMainHeaderCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(QYZYLiveMainHeaderCell.class)];
}

- (void)setHotArray:(NSArray<QYZYLiveMainHotModel *> *)hotArray {
    _hotArray = hotArray;
    [self.collectionView reloadData];
}

- (void)setBannerArray:(NSArray<QYZYLiveBannerModel *> *)bannerArray {
    _bannerArray = bannerArray;
    
    self.cycleView.imageURLStringsGroup = [bannerArray qmui_mapWithBlock:^id _Nonnull(QYZYLiveBannerModel * _Nonnull item) {
        return item.img ? item.img : @"";
    }];
    self.cycleView.titlesGroup = [bannerArray qmui_mapWithBlock:^id _Nonnull(QYZYLiveBannerModel * _Nonnull item) {
        return item.title ? item.title : @"";
    }];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QYZYLiveMainHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QYZYLiveMainHeaderCell.class) forIndexPath:indexPath];
    if (self.hotArray.count > indexPath.row) {
        cell.hotModel = self.hotArray[indexPath.row];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hotArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(68, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hotArray.count > indexPath.row) {
        QYZYLiveMainHotModel *hotModel = self.hotArray[indexPath.row];
        [self enterLiveDetailWithAnchorId:hotModel.anchorId];
    }
}

- (SDCycleScrollView *)cycleView {
    if (_cycleView == nil) {
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"logo_placeholder"]];
        _cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleView.imageURLStringsGroup = @[];
    }
    return _cycleView;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.bannerArray.count > index) {
        QYZYLiveBannerModel *bannerModel = self.bannerArray[index];
        if ([bannerModel.relateType isEqualToString:@"8"]) {
            [self enterLiveDetailWithAnchorId:bannerModel.link];
        }
    }
}

- (void)enterLiveDetailWithAnchorId:(NSString *)anchorId {
    QYZYLiveDetailViewController *vc = [QYZYLiveDetailViewController new];
    vc.anchorId = anchorId;
    vc.hidesBottomBarWhenPushed = YES;
    [UIViewController.currentViewController.navigationController pushViewController:vc animated:YES];
}

@end
