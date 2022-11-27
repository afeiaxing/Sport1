//
//  QYZYNewsCommentsApi.h
//  QYZY
//
//  Created by jsgordong on 2022/10/3.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYNewsCommentsApi : YTKRequest
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *newsId;
@end

NS_ASSUME_NONNULL_END
