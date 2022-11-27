//
//  QYZYMycollectApi.h
//  QYZY
//
//  Created by jspatches on 2022/10/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMycollectApi : YTKRequest
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, assign) NSInteger pageSize;
@end

NS_ASSUME_NONNULL_END
