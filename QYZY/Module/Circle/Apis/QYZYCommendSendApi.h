//
//  QYZYCommendSendApi.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/3.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYCommendSendApi : YTKRequest

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *isComment;

@property (nonatomic, copy) NSString *replyId;

@end

NS_ASSUME_NONNULL_END
