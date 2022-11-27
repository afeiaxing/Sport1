//
//  QYZYPostApi.h
//  QYZY
//
//  Created by jspatches on 2022/10/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYPostApi : YTKRequest
@property (nonatomic, copy) NSString *authorId;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@end

NS_ASSUME_NONNULL_END
