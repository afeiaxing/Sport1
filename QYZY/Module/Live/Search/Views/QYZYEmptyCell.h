//
//  QYZYEmptyCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EmptyType) {
    EmptyTypeNoData,
    EmptyTypeNoResult
};

@interface QYZYEmptyCell : UITableViewCell

@property (nonatomic, assign) EmptyType type;

@end

NS_ASSUME_NONNULL_END
