//
//  QYZYTeamStaticShowupModel.h
//  QYZY
//
//  Created by jsmatthew on 2022/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYTeamStaticShowupModel : NSObject
// itemNameValue
@property (nonatomic, copy) NSString *itemNameValue;
// hostTeamValue
@property (nonatomic, copy) NSString *hostTeamValue;
// guestTeamValue
@property (nonatomic, copy) NSString *guestTeamValue;
// hostTeamValueRate 主队 比例
@property (nonatomic, assign) CGFloat hostTeamValueRate;
// guestTeamValueRate 客队比例
@property (nonatomic, assign) CGFloat guestTeamValueRate;

+ (QYZYTeamStaticShowupModel *)configWithHostTeamValue:(NSString *)hostTeamValue
                                                 guestTeamValue:(NSString *)guestTeamValue
                                         itemNameValue:(NSString *)itemNameValue;

@end

NS_ASSUME_NONNULL_END
