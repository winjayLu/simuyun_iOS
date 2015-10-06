//
//  YTBadgeTool.m
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBadgeTool.h"
#import "APService.h"

@implementation YTBadgeTool

/**
 *  修改BadgeNumber   减一
 *
 */
- (void)makeBadge
{
    NSInteger oldNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    NSInteger newNumber = oldNumber--;
    if (newNumber < 0) return;
    // 修改Jpush缓存区的数据
    [APService setBadge:newNumber];
    [UIApplication sharedApplication].applicationIconBadgeNumber = newNumber;
}

@end
