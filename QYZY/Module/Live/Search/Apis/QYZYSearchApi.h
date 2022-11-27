//
//  QYZYSearchApi.h
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYSearchApi : YTKRequest

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, assign) NSInteger searchType;

@end

NS_ASSUME_NONNULL_END
