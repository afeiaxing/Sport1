//
//  QYZYPlayerContentCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYPlayerContentCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
