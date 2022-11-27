//
//  QYZYRIMModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYRIMModel : NSObject<NSSecureCoding>
@property (nonatomic ,strong) NSString *appId;
@property (nonatomic ,strong) NSString *timeThreshold;
@property (nonatomic ,strong) NSString *infoOpenFlag;
@property (nonatomic ,strong) NSString *infoPublicKey;
@end

NS_ASSUME_NONNULL_END
