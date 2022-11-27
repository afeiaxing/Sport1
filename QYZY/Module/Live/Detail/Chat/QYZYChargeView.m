//
//  QYZYChargeView.m
//  QYZY
//
//  Created by jspollo on 2022/10/4.
//

#import "QYZYChargeView.h"
#import "QYZYChargeCell.h"
//#import "QYZYIAPManager.h"

@interface QYZYChargeView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation QYZYChargeView
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYChargeCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(QYZYChargeCell.class)];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 50);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QYZYChargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QYZYChargeCell.class) forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    weakSelf(self);
//    [QYZYIAPManager.shareInstace requestPurchaseWithProductId:@"dkakdjgkgk" completion:^(QYZYIAPPurchaseType type, NSData * _Nullable data) {
//        strongSelf(self);
//        if (type == QYZYIAPPurchaseNotAllow) {
////            [self qyzy_showMsg:@"获取产品信息失败"];
//        }
//    }];
}

@end
