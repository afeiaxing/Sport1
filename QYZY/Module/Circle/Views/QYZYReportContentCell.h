//
//  QYZYReportContentCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYReportContentCell : UITableViewCell

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
