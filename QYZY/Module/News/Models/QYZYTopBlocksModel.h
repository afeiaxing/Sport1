//
//  QYZYTopBlocksModel.h
//  QYZY
//
//  Created by jsmaster on 10/1/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYTopBlocksModel : NSObject

@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, copy) NSString *jumpId;
@property(nonatomic, copy) NSString *newsId;
@property(nonatomic, copy) NSString *commentCount;
@property(nonatomic, copy) NSString *createdDate;

@end

NS_ASSUME_NONNULL_END
