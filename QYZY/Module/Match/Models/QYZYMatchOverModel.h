//
//  QYZYMatchOverModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchOverModel : NSObject
@property (nonatomic ,strong) NSString *time;
@property (nonatomic ,strong) NSString *cnText;
@property (nonatomic ,strong) NSString *occurTime;
@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) NSString *statusName;
@property (nonatomic ,assign) BOOL isBasket; /// 是否篮球，默认否
@end

NS_ASSUME_NONNULL_END
