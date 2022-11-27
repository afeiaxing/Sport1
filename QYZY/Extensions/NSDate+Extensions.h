//
//  NSDate+Extensions.h
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Extensions)

- (NSUInteger)getDay;
- (NSDate *)endOfMonth;
- (NSInteger)weekday;
- (NSString *)xm_stringWithFormat:(NSString *)format;
+ (NSInteger)qyzy_getCurrentMillisecondTimestamp;
+ (NSString *)getDateStringWithDate:(NSDate *)date formatter:(NSString *)formatter;
+ (NSInteger)getDaysInMonthFromDate:(NSDate*)date;

@end

NS_ASSUME_NONNULL_END
