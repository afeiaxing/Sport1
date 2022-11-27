//
//  QYZYHotHeadView.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TapCircleBlock)(QYZYCircleListModel *model);

@interface QYZYHotHeadView : UIView

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, copy) TapCircleBlock tapCircleBlock;

@end

NS_ASSUME_NONNULL_END
