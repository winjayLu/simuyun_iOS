//
//  YTJpushTool.m
//  simuyun
//
//  Created by Luwinjay on 15/11/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTJpushTool.h"
#import "JPUSHService.h"

@implementation YTJpushTool


/**
 *  修改BadgeNumber   减一
 *
 */
+ (void)makeBadge
{
//    NSInteger oldNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
//    NSInteger newNumber = oldNumber--;
//    if (newNumber < 0) return;
    // 修改Jpush缓存区的数据
    [JPUSHService setBadge:0];
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


/**
 *  推送消息
 */
static YTJpushModel *_jpushModel;

/**
 *  获取上次存储的启动信息
 */
+ (YTJpushModel *)jpush
{
    return _jpushModel;
}

/**
 *  存储启动信息
 */
+ (void)saveJpush:(YTJpushModel *)jpush
{
    _jpushModel = jpush;
    
}


static NSDictionary *_test;

+ (NSDictionary *)test
{
    return _test;
}

+ (void)saveTest:(NSDictionary *)test
{
    _test = test;
}

@end
