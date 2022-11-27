//
//  QYZYSearchUtils.h
//  QYZY
//
//  Created by jsmatthew on 2022/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QYZYSearchUtils : NSObject

typedef NS_ENUM(NSInteger, SearchType) {
    SearchHistoryType = 0,
    SearchHotType,
    Result_anchor,
    Result_live,
    Empty,
};



@end

NS_ASSUME_NONNULL_END
