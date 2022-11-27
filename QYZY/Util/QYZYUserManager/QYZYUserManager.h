//
//  QYZYUserManager.h
//  QYZY
//
//  Created by jsmaster on 9/30/22.
//

#import <Foundation/Foundation.h>
#import "QYZYUserModel.h"
#import "QYZYMineModel.h"

//@class QYZYUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface QYZYUserManager : NSObject

@property(nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong, nullable) QYZYUserModel *userModel;
@property (nonatomic, strong, nullable) QYZYMineModel *mineModel;

+ (instancetype)shareInstance;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (void)saveUserModel:(QYZYUserModel <NSCoding> * __nullable)model;
- (void)saveMineModel:(QYZYMineModel <NSCoding> * __nullable)model;

@end

NS_ASSUME_NONNULL_END
