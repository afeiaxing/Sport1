//
//  QYZYMineTableViewCell.h
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QYZYTableViewnCellBookBlock)(NSInteger tag);

@interface QYZYMineTableViewCell : UITableViewCell

@property (nonatomic, copy) QYZYTableViewnCellBookBlock actionBlock;
@end

NS_ASSUME_NONNULL_END
