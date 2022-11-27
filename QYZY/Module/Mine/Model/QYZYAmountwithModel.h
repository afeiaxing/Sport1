//
//  QYZYAmountwithModel.h
//  QYZY
//
//  Created by jspatches on 2022/10/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYAmountwithModel : NSObject
/// 余额（球钻）
@property (nonatomic, assign) double balance;
/// 积分
@property (nonatomic, assign) NSInteger integral;
/// 用户id
@property (nonatomic, assign) NSInteger userId;


@end

NS_ASSUME_NONNULL_END
