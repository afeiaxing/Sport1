//
//  QYZYChargeViewController.m
//  QYZY
//
//  Created by jsmaster on 10/14/22.
//

#import "QYZYChargeViewController.h"
#import "QYZYChargeModel.h"
#import "QYZYChargeCollectionViewCell.h"
#import <FGIAPService/FGIAPManager.h>
#import <FGIAPService/FGIAPProductsFilter.h>
#import "QYZYCreateRechargeOrderApi.h"
#import "QYZYIAPManager.h"
#import "QYZYUploadPayStatusApi.h"
#import "QYZYAmountwithApi.h"
#import "QYZYAmountwithModel.h"

NSString * const QYZYIAPPaySuccessNotification = @"com.domain.order.check.success.notification";

@interface QYZYChargeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FGIAPVerifyTransaction>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) NSArray <QYZYChargeModel *> *datasource;
@property (nonatomic, strong) FGIAPProductsFilter *filter;
@property(nonatomic, copy) NSString *payOrderId;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@end

@implementation QYZYChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"充值中心";
    self.fd_prefersNavigationBarHidden = YES;
    [self requestBalance];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(QYZYChargeCollectionViewCell.class) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass(QYZYChargeCollectionViewCell.class)];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake((ScreenWidth - 50) / 3.0, (138 - 10)/ 2.0);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    [[FGIAPManager shared] setConfigureWith: self];
    self.filter = [[FGIAPProductsFilter alloc] init];
    
}

- (void)requestBalance {
    QYZYAmountwithApi *amountApi = [QYZYAmountwithApi new];
    [amountApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        QYZYAmountwithModel *model = [QYZYAmountwithModel yy_modelWithJSON:[request.responseObject objectForKey:@"data"]];
        
        QYZYUserModel *userModel = QYZYUserManager.shareInstance.userModel;
        userModel.balance = model.balance;
        [QYZYUserManager.shareInstance saveUserModel:userModel];
        
        self.amountLabel.text = [NSString stringWithFormat:@"%.2f",model.balance/100];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@",request.error);
    }];
}

- (IBAction)chargeBtnDidClicked:(UIButton *)sender {
    QYZYChargeModel *model = [self.datasource qyzy_findFirstWithFilterBlock:^BOOL(QYZYChargeModel   * _Nonnull obj) {
        return obj.selected == true;
    }];
    if (model == nil) {
        [self.view qyzy_showMsg:@"购买失败， 请重试!"];
        return;
    }
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"购买提示" message:[NSString stringWithFormat:@"确定花费%@元购买%@", model.price, model.desc] preferredStyle:UIAlertControllerStyleAlert];
    weakSelf(self);
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        strongSelf(self);
        QYZYCreateRechargeOrderApi *api = [QYZYCreateRechargeOrderApi new];
        api.amount = [NSNumber numberWithInt:[model.price intValue] * 100];
        [self.view qyzy_showLoadingWithMsg:@"购买中"];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
           
            NSString *payOrderId = [[request.responseObject objectForKey:@"bizResult"] objectForKey:@"payOrderId"];
            if (payOrderId.length <= 0) {
                [self.view qyzy_showMsg:@"购买失败， 请重试!"];
                return;
            }
            self.payOrderId = payOrderId;
            
            [self.filter requestProductsWith:[NSSet setWithObject:[model.ID stringValue]] completion:^(NSArray<SKProduct *> * _Nonnull products) {
                [[FGIAPManager shared].iap buyProduct:products.firstObject onCompletion:^(NSString * _Nonnull message, FGIAPManagerPurchaseRusult result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        strongSelf(self);
                        if (result == FGIAPManagerPurchaseRusultSuccess) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:QYZYIAPPaySuccessNotification object:nil];
                            [self requestBalance];
                            [self.view qyzy_showMsg:@"购买成功!"];
                        } else {
                            [self.view qyzy_showMsg:@"购买失败， 请重试!"];
                        }
                    });
                }];
            }];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [self.view qyzy_showMsg:request.error.localizedDescription];
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
   
    [ac addAction:cancelAction];
    [ac addAction:sureAction];
    
    [self presentViewController:ac animated:true completion:nil];
    
}

- (IBAction)senderbackAction {
    if (self.navigationController.viewControllers.count <= 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - FGIAPVerifyTransaction
- (void)pushSuccessTradeReultToServer:(NSString *)receipt transaction:(SKPaymentTransaction *)transaction complete:(FGIAPVerifyTransactionPushCallBack)handler{

    NSString *payOrderId = [[NSUserDefaults standardUserDefaults] objectForKey:transaction.transactionIdentifier];
    if (!payOrderId) {
        payOrderId = self.payOrderId;
    }
    
    if (payOrderId == nil) {
        return;
    }
    
    
    QYZYUploadPayStatusApi *api = [QYZYUploadPayStatusApi new];
    api.payOrderId = payOrderId;
    //api.goodsId = transaction.payment.productIdentifier;
    api.goodsId = @"QTX1234567";
    api.payload = receipt;
    api.transactionId = transaction.transactionIdentifier;
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ([[request.responseObject objectForKey:@"retCode"] isEqualToString:@"SUCCESS"]) {
            if (handler) {
                handler(@"Order Check Success", nil);
            }
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:self.payOrderId forKey:transaction.transactionIdentifier];
            if (handler) {
                handler(@"Order Check Error", [NSError errorWithDomain:@"com.domain.order.check.error" code:-1000 userInfo:@{NSLocalizedDescriptionKey: @"Order Check Error"}]);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [[NSUserDefaults standardUserDefaults] setObject:self.payOrderId forKey:transaction.transactionIdentifier];
        if (handler) {
            handler(@"Order Check Error", [NSError errorWithDomain:@"com.domain.order.check.error" code:-1000 userInfo:@{NSLocalizedDescriptionKey: @"Order Check Error"}]);
        }
    }];
}

- (void)pushServiceErrorLogStatistics:(NSDictionary *)logStatistics error:(FGIAPServiceErrorType)error{
    
    if (error != FGIAPServiceErrorTypeNone) {
        [self.view qyzy_showMsg:@"购买失败， 请重试"];
    }
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QYZYChargeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(QYZYChargeCollectionViewCell.class) forIndexPath:indexPath];
    cell.model = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    for (QYZYChargeModel *model in self.datasource) {
        model.selected = false;
    }
    
    self.datasource[indexPath.row].selected = true;
    
    [collectionView reloadData];
}

- (NSArray<QYZYChargeModel *> *)datasource {
    if (_datasource == nil) {
        NSArray <NSDictionary <NSString *, NSString *> *> *ids = @[@{@"ID": @1001, @"desc": @"8财富豆", @"selected": @1, @"price": @12},
                                                                   @{@"ID": @1002, @"desc": @"35财富豆", @"selected": @0, @"price": @50},
                                                                   @{@"ID": @1003, @"desc": @"47财富豆", @"selected": @0, @"price": @68},
                                                                   @{@"ID": @1004, @"desc": @"68财富豆", @"selected": @0, @"price": @98},
                                                                   @{@"ID": @1005, @"desc": @"131财富豆", @"selected": @0, @"price": @188},
                                                                   @{@"ID": @1006, @"desc": @"201财富豆", @"selected": @0, @"price": @288}];
        _datasource = [NSArray yy_modelArrayWithClass:QYZYChargeModel.class json:ids];
    }
    return _datasource;
}

@end
