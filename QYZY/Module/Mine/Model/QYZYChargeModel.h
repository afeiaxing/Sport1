//
//  QYZYChargeModel.h
//  QYZY
//
//  Created by jsmaster on 10/14/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYChargeModel : NSObject

@property(nonatomic, copy) NSNumber *ID;
@property(nonatomic, copy) NSNumber *price;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
