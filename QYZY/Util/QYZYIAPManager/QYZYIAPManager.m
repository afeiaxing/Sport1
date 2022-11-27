//
//  QYZYIAPManager.m
//  QYZY
//
//  Created by jspollo on 2022/10/3.
//

#import "QYZYIAPManager.h"
#import <StoreKit/StoreKit.h>

@interface QYZYIAPManager()<SKPaymentTransactionObserver , SKProductsRequestDelegate>
@property (nonatomic ,strong) NSString *currentProductId;
@property (nonatomic ,strong) QYZYIAPPurchaseBlock purchaseBlock;
@end

@implementation QYZYIAPManager
+ (instancetype)shareInstace {
    static dispatch_once_t onceToken;
    static QYZYIAPManager *shared;
    dispatch_once(&onceToken, ^{
        shared = [[QYZYIAPManager alloc] init];
    });
    return shared;
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestPurchaseWithProductId:(NSString *)productId completion:(QYZYIAPPurchaseBlock)completion {
    self.currentProductId = productId;
    self.purchaseBlock = completion;
    if (productId) {
        if ([SKPaymentQueue canMakePayments]) {
            NSSet *IDSet = [NSSet setWithArray:@[productId]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:IDSet];
            request.delegate = self;
            [request start];
        }
        else {
            !self.purchaseBlock ? : self.purchaseBlock(QYZYIAPPurchaseNotAllow , nil);
        }
    }
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *products = response.products;
    if (products.count <= 0) {
        !self.purchaseBlock ? : self.purchaseBlock(QYZYIAPPurchaseNotProduct , nil);
        return;
    }
    
    SKProduct *product = nil;
    for (SKProduct *tempProduct in products) {
        if ([tempProduct.productIdentifier isEqualToString:self.currentProductId]) {
            product = tempProduct;
            break;
        }
    }
    if (product == nil) {
        !self.purchaseBlock ? : self.purchaseBlock(QYZYIAPPurchaseNotProduct , nil);
        return;
    }
    
#if DEBUG
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[products count]);
    NSLog(@"产品描述:%@",[product description]);
    NSLog(@"产品标题%@",[product localizedTitle]);
    NSLog(@"产品本地化描述%@",[product localizedDescription]);
    NSLog(@"产品价格：%@",[product price]);
    NSLog(@"产品productIdentifier：%@",[product productIdentifier]);
#endif
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [SKPaymentQueue.defaultQueue addPayment:payment];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    !self.purchaseBlock ? : self.purchaseBlock(QYZYIAPPurchaseNotProduct , nil);
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                
                break;
            case SKPaymentTransactionStatePurchased:
                !self.purchaseBlock ? : self.purchaseBlock(QYZYIAPPurchaseSuccess , nil);
                break;
            case SKPaymentTransactionStateFailed:
            {
                if (transaction.error.code != SKErrorPaymentCancelled) {
                    !self.purchaseBlock ? : self.purchaseBlock(QYZYIAPPurchaseFail , nil);
                }
                else {
                    !self.purchaseBlock ? : self.purchaseBlock(QYZYIAPPurchaseCancel , nil);
                }
                [SKPaymentQueue.defaultQueue finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored:
                [SKPaymentQueue.defaultQueue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                
                break;
            default:
                break;
        }
    }
}

@end
