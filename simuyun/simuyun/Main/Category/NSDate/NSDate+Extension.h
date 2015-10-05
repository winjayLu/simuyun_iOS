//
//  NSDate+Extension.h
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
/**
 *  计算toDate和当前时间差距
 */
- (NSDateComponents *)componentsToDate:(NSDate *)toDate;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为明天
 */
- (BOOL)isTomorrow;
/**
 *  将一个时间变为只有年月日的时间(时分秒都是0)
 */
- (NSDate *)ymd;
/**
 *  根据传入的format,返回对应格式的字符串
 */
- (NSString *)stringWithFormater:(NSString *)format;
@end
