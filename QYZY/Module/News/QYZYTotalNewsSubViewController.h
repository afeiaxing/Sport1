//
//  QYZYTotalNewsSubViewController.h
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYTotalNewsLabelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYTotalNewsSubViewController : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic, strong) QYZYTotalNewsLabelModel *model;
@end

NS_ASSUME_NONNULL_END
