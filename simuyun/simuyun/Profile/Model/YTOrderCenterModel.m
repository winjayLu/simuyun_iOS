//
//  YTOrderCenterModel.m
//  simuyun
//
//  Created by Luwinjay on 15/10/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTOrderCenterModel.h"
#import "NSString+Extend.h"
#import "NSDate+Extension.h"

@implementation YTOrderCenterModel

- (void)setCreate_time:(NSString *)create_time
{
    NSDate *date = [create_time stringWithDate:@"yyyy-MM-ddHH:mm:ss"];
    _create_time = [date stringWithFormater:@"yyyy-MM-dd HH:mm"];
}

- (void)setEnd_date:(NSString *)end_date
{
    NSDate *date = [end_date stringWithDate:@"yyyy-MM-dd"];
    _end_date = [date stringWithFormater:@"yyyy年MM月dd日"];
}


@end
