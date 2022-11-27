//
//  QYZYRIMManager.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>
#import "QYZYRIMModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYRIMManager : NSObject
@property (nonatomic ,strong) NSString *appKey;
@property (nonatomic ,strong) QYZYRIMModel *rIMModel;
+ (instancetype)shareInstace;
- (void)requestKeyData;
- (void)connectRIM;
@end

NS_ASSUME_NONNULL_END
