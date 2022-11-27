//
//  QYZYSettingPaswwordApi.h
//  QYZY
//
//  Created by jsmaster on 10/4/22.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYSettingPaswwordApi : YTKRequest

@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *passWord;
@property(nonatomic, copy) NSString *ticket;
@end

NS_ASSUME_NONNULL_END
