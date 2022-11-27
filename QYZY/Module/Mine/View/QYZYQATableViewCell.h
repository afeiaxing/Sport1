//
//  QYZYQATableViewCell.h
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import <UIKit/UIKit.h>
#import "QYZYQARouModel.h"
#import "NSString+Category.h"
#import "UILabel+XMUtils.h"


NS_ASSUME_NONNULL_BEGIN

@class QYZYQARouModel;

@interface QYZYQATableViewCell : UITableViewCell

@property (nonatomic, copy) void(^clickSpecificationBlock)(void);

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier rowModel:(QYZYQARouModel *)model;
@end

NS_ASSUME_NONNULL_END
