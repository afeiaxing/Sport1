//
//  QYZYReportApi.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/4.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYReportApi : YTKRequest

@property (nonatomic, copy) NSString *idType;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, copy) NSString *reasonId;

@property (nonatomic, copy) NSString *reportBy;

@end

NS_ASSUME_NONNULL_END
