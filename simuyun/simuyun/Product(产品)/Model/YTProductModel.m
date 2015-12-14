//
//  YTProductModel.m
//  simuyun
//
//  Created by Luwinjay on 15/10/15.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTProductModel.h"
#import "NSDate+Extension.h"
#import "NSString+Extend.h"

@implementation YTProductModel


/**
 *  投资起点
 *
 */
- (void)setBuy_start:(NSString *)buy_start
{

    _buy_start = [NSString stringWithFormat:@"%@万",buy_start];
}


/**
 *  封闭期
 *
 */
- (void)setClose_stage:(NSString *)close_stage
{
    _close_stage = [NSString stringWithFormat:@"%@个月",close_stage];
}

/**
 *  投资期限
 *
 */
- (void)setTerm:(NSString *)term
{
    _term = [NSString stringWithFormat:@"%@个月",term];
}


/**
 *  预期收益
 */
- (void)setExpected_yield:(NSString *)expected_yield
{
    _expected_yield = [NSString stringWithFormat:@"%@%%",expected_yield];
}

/**
 *  截止报备时间
 *
 */
- (void)setPub_end_time:(NSString *)pub_end_time
{
    _pub_end_time = pub_end_time;
    
    if (_pub_end_time.length == 0) return;
    NSDate *date = [NSDate date];
    NSDate *endTime = [pub_end_time stringWithDate:@"yyyy-MM-dd HH:mm"];
    _componentsDate = [date componentsToDate:endTime];
}



@end
