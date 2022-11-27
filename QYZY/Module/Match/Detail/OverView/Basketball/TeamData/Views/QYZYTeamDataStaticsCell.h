//
//  QYZYTeamDataStaticsCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import <UIKit/UIKit.h>
#import "QYZYTeamStaticShowupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYTeamDataStaticsCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) QYZYTeamStaticShowupModel *model;

- (void)updateView;

@end

NS_ASSUME_NONNULL_END
