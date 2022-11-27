//
//  QYZYNewsDetailCurrentNewsModel.h
//  QYZY
//
//  Created by jsgordong on 2022/10/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYNewsDetailCurrentNewsModel : NSObject
@property(nonatomic, copy) NSString *ID;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imgUrl;
@property(nonatomic, copy) NSString *jumpId;
@property(nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *commentCount;
@property (nonatomic, copy) NSString *likeCount;
@property(nonatomic, copy) NSString *createdDate;

@end

NS_ASSUME_NONNULL_END
