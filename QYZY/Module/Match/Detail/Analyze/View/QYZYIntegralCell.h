//
//  QYZYIntegralCell.h
//  QYZY
//
//  Created by jsgordong on 2022/10/24.
//

#import <UIKit/UIKit.h>
#import "QYZYMatchAnalyzeRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYIntegralCell : UITableViewCell
@property (nonatomic ,strong) QYZYMatchAnalyzeRankSubModel *subModel;
@property (nonatomic ,assign) BOOL isBasket; /// 是否篮球，默认否
@end

NS_ASSUME_NONNULL_END
