//
//  NSDate+Extension.m
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  计算toDate和当前时间差距
 */
- (NSDateComponents *)componentsToDate:(NSDate *)toDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
    
    return components;
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    // 获取系统自带的日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 取出当前时间对应年份
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    // 取出微博创建时间对应年份
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    // 判断是否相等
    return nowYear == selfYear;
}

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    // 获取系统自带的日历对象
    /**
        判断两个日期是否相差几天时
        先将两个日期的,时分秒清空,再进行判断
     */
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitDay fromDate:self.ymd toDate:[NSDate date].ymd options:0].day == 0;
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitDay fromDate:self.ymd toDate:[NSDate date].ymd options:0].day == 1;
}
/**
 *  是否为明天
 */
- (BOOL)isTomorrow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:NSCalendarUnitDay fromDate:self.ymd toDate:[NSDate date].ymd options:0].day == -1;
}

/**
 *  将一个时间变为只有年月日的时间(时分秒都是0)
 */
- (NSDate *)ymd
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd 00:00:00";
    NSString *dateStr = [formatter stringFromDate:self];
    return [formatter dateFromString:dateStr];
}
/**
 *  根据传入的format,返回对应格式的字符串
 */
- (NSString *)stringWithFormater:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

@end
