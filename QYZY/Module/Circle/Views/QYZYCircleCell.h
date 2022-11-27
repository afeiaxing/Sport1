//
//  QYZYCircleCell.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/2.
//

#import <UIKit/UIKit.h>
#import "QYZYCircleContentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^AvatarTapBlock)(NSString *userId);

typedef void(^CircleListShareTapBlock)(QYZYCircleContentModel *model);

typedef void(^CircleListLikeTapBlock)(QYZYCircleContentModel *model);

@interface QYZYCircleCell : UITableViewCell

@property (nonatomic, strong) QYZYCircleContentModel *model;

@property (nonatomic, copy) AvatarTapBlock avatarTapBlock;

@property (nonatomic, copy) CircleListShareTapBlock shareTapBlock;

@property (nonatomic, copy) CircleListLikeTapBlock likeTapBlock;

@end

NS_ASSUME_NONNULL_END
