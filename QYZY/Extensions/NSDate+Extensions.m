//
//  NSDate+Extensions.m
//  QYZY
//
//  Created by jsmaster on 9/28/22.
//

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

/// 获取当前时间戳 【毫秒级】
+ (NSInteger)qyzy_getCurrentMillisecondTimestamp {
    NSTimeInterval interval = [NSDate.date timeIntervalSince1970];
    long long milliseconds = interval * 1000;
    return milliseconds;
}

+ (NSString *)getDateStringWithDate:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter *forM = [[NSDateFormatter alloc] init];
    [forM setDateFormat:formatter];
    
    return [forM stringFromDate:date];
}

+ (NSInteger)getDaysInMonthFromDate:(NSDate*)date {
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days  = [c rangeOfUnit:NSCalendarUnitDay
                            inUnit:NSCalendarUnitMonth
                           forDate:date];
    return days.length;
}

- (NSUInteger)getDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
    return [dayComponents day];
}

- (NSDate *)dateAfterDay:(NSUInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterDay;
}

- (NSDate *)dateafterMonth:(int)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];
    return dateAfterMonth;
}

- (NSDate *)beginningOfMonth {
    NSUInteger i = - [self getDay] + 1;
    return [self dateAfterDay: i];
}

- (NSDate *)nextBeginningOfMonth {
    return [[self beginningOfMonth] dateafterMonth:1];
}

- (NSDate *)endOfMonth {
    return [[self nextBeginningOfMonth] dateAfterDay:-1];
}

- (NSString *)xm_stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale currentLocale]];
    return [formatter stringFromDate:self];
}

- (NSDateComponents *)dateComponents:(NSUInteger)components {
    return [[NSCalendar currentCalendar] components:components fromDate:self];
}

- (NSDateComponents *)dateComponentsWeekday {
    NSUInteger components = (NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekday |
                             NSCalendarUnitMonth | NSCalendarUnitYear);
    return [self dateComponents:components];
}

- (NSInteger)weekday {
    return [self dateComponentsWeekday].weekday;
}

@end
