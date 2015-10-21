//
//  YTResourcesTool.m
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTResourcesTool.h"

@implementation YTResourcesTool




// 用户信息
static YTResources *_resources;


/**
 *  获取上次存储的启动信息
 */
+ (YTResources *)resources
{
    return _resources;
}

/**
 *  存储启动信息
 */
+ (void)saveResources:(YTResources *)resources
{
    _resources = resources;
}

@end
