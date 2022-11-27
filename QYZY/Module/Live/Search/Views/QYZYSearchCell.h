//
//  QYZYSearchCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import <UIKit/UIKit.h>
#import "QYZYSearchUtils.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SearchKeyBlock)(NSString *searchKey);

@interface QYZYSearchCell : UITableViewCell

@property (nonatomic, assign) SearchType type;

@property (nonatomic, strong) NSMutableArray *searchKeys;

@property (nonatomic, copy) dispatch_block_t clearClickBlock;

@property (nonatomic, copy) SearchKeyBlock searchKeyBlock;

@end

NS_ASSUME_NONNULL_END
