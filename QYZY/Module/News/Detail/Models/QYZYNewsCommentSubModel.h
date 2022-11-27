//
//  QYZYNewsCommentSubModel.h
//  QYZY
//
//  Created by jsgordong on 2022/10/4.
//

#import <Foundation/Foundation.h>
#import "QYZYNewsCommentSubParentModel.h"
#import "QYZYNewsCommentSubSonCommentsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYNewsCommentSubModel : NSObject
@property (nonatomic, strong) QYZYNewsCommentSubParentModel *parent;
@end

NS_ASSUME_NONNULL_END
