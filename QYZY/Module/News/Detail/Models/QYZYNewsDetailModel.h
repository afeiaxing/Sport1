//
//  QYZYNewsDetailModel.h
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import <Foundation/Foundation.h>
@class QYZYNewsDetailNewsModel;

NS_ASSUME_NONNULL_BEGIN

@interface QYZYNewsDetailModel : NSObject
@property (nonatomic, strong) QYZYNewsDetailNewsModel *news;
@property (nonatomic, strong) NSArray *currentNews;
@end

NS_ASSUME_NONNULL_END
