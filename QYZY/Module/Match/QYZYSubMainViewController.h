//
//  QYZYSubMainViewController.h
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import "QYZYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYSubMainViewController : QYZYBaseViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,assign) QYZYMatchType matchType;
@property (nonatomic, strong) NSString *currentDateString;
- (void)requestData;
@end

NS_ASSUME_NONNULL_END
