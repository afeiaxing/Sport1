//
//  QYZYLiveRankModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYLiveRankModel : NSObject
@property (nonatomic, strong) NSString * headImgUrl;
@property (nonatomic, strong) NSString * rankType;//1上升2下降0排名不变
@property (nonatomic, strong) NSString * nickname;
@property (nonatomic, strong) NSString * fansCount;
@property (nonatomic, strong) NSNumber * anchorContribution;
@property (nonatomic, strong) NSString * rankOrder;
@property (nonatomic, assign) BOOL focusStatus;
@property (nonatomic, strong) NSString * userId;
@end

NS_ASSUME_NONNULL_END
