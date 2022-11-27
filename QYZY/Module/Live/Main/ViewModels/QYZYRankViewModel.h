//
//  QYZYRankViewModel.h
//  QYZY
//
//  Created by jspatches on 2022/10/1.
//

#import <Foundation/Foundation.h>
#import "QYZYRankApi.h"
#import "QYZYRankModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QYZYRankViewModel : NSObject
- (void)requestRankDataWithtype:(NSNumber *)type isDay:(BOOL)isDay completion:(void(^)(NSArray <QYZYRankModel *> *array))completion;

@end

NS_ASSUME_NONNULL_END
