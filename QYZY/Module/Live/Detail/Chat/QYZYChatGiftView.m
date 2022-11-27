//
//  QYZYChatGiftView.m
//  QYZY
//
//  Created by jspollo on 2022/10/2.
//

#import "QYZYChatGiftView.h"
#import "QYZYChatGiftCell.h"
#import "QYZYChargeView.h"
@interface QYZYChatGiftView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *closeView;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (nonatomic ,strong) QYZYChatGiftModel *clickModel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;

@end

@implementation QYZYChatGiftView

- (IBAction)chargeButton:(id)sender{
//    QYZYChargeView *chargeView = [NSBundle.mainBundle loadNibNamed:NSStringFromClass(QYZYChargeView.class) owner:self options:nil].firstObject;
//    chargeView.frame = CGRectMake(0, 45, ScreenWidth, self.bounds.size.height - 45);
//    [self addSubview:chargeView];
    if (self.chargeBlock) {
        self.chargeBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYChatGiftCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(QYZYChatGiftCell.class)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction)];
    [self.closeView addGestureRecognizer:tap];
    self.closeView.userInteractionEnabled = YES;
    self.clickButton.layer.cornerRadius = 4;
    self.topLine.backgroundColor = rgba(182, 188, 203 , 0.2);
    self.bottomLine.backgroundColor = rgba(182, 188, 203 , 0.2);
    [self.clickButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    self.balanceLabel.textColor = rgb(41, 69, 192);
    self.balanceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.balanceLabel.text = [NSString stringWithFormat:@"财富豆%@",[self getBalance]];
    [self.chargeButton setTitle:@"" forState:UIControlStateNormal];
}

- (NSString *)getBalance {
    if (QYZYUserManager.shareInstance.userModel) {
        NSInteger balance = QYZYUserManager.shareInstance.userModel.balance;
        if (balance % 100 == 0) {
            return [NSString stringWithFormat:@"%0.0f",balance/100.0];
        }
        else {
            return [NSString stringWithFormat:@"%0.2f",balance/100.0];
        }
    }
    return @"0";
}

- (void)updateBalance {
    self.balanceLabel.text = [NSString stringWithFormat:@"财富豆%@",[self getBalance]];
}

- (void)closeAction {
    self.hidden = YES;
}

- (void)clickAction {
    if (self.clickModel) {
        !self.clickBlock ? : self.clickBlock(self.clickModel);
    } else {
        [self qyzy_showMsg:@"您还没选中礼物"];
    }
}

- (void)setGiftArray:(NSArray<QYZYChatGiftModel *> *)giftArray {
    _giftArray = giftArray;
    [self.collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QYZYChatGiftCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QYZYChatGiftCell.class) forIndexPath:indexPath];
    if (self.giftArray.count > indexPath.row) {
        cell.giftModel = self.giftArray[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.giftArray enumerateObjectsUsingBlock:^(QYZYChatGiftModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isClick = indexPath.row == idx;
    }];
    if (self.giftArray.count > indexPath.row) {
        self.clickModel = self.giftArray[indexPath.row];
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.giftArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(89, 89);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}
@end
