//
//  QYZYTotalNewsLabelModel.h
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYTotalNewsLabelModel : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *jumpUrl;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger mediaType;

@property (copy, nonatomic) NSString *sportType;

@property (copy, nonatomic) NSString *categoryId;

@end

NS_ASSUME_NONNULL_END
