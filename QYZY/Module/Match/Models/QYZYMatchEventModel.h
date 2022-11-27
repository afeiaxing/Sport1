//
//  QYZYMatchEventModel.h
//  QYZY
//
//  Created by jspollo on 2022/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYMatchEventModel : NSObject
@property (nonatomic ,strong) NSString *eventId;
@property (nonatomic ,strong) NSString *team;
@property (nonatomic ,strong) NSString *iconType;
@property (nonatomic ,strong) NSString *typeId;
@property (nonatomic ,strong) NSString *goalType;
@property (nonatomic ,strong) NSString *playerName2;
@property (nonatomic ,strong) NSString *playerName;
@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) NSString *content2;
@property (nonatomic ,strong) NSString *occurTime;
@property (nonatomic ,strong) NSString *overTime;
@property (nonatomic ,strong) NSString *confirmResult;
@property (nonatomic ,strong) NSString *substitute;
@property (nonatomic ,strong) NSString *scores;
@property (nonatomic ,strong) NSString *stage;

@end

NS_ASSUME_NONNULL_END
