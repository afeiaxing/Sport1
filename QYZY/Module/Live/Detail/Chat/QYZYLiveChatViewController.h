//
//  QYZYLiveChatViewController.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveChatViewController : UIViewController<JXCategoryListContentViewDelegate>
@property (nonatomic ,strong) NSString *chatId;
@property (nonatomic ,strong) NSString *anchorId;
@end

NS_ASSUME_NONNULL_END
