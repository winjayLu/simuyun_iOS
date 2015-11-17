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
 *  加载程序启动信息
 */
+ (void)loadResourcesWithresult:(void (^)(BOOL result))result
{
    // 已经有启动信息,直接返回
    if (_resources) {
        result(YES);
        return;
    }
    
    // 去服务器获取
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"os"] = @"ios-appstore";
    dict[@"version"] = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [YTHttpTool get:YTGetResources params:dict success:^(NSDictionary *responseObject)
     {
         [self saveResources:[YTResources objectWithKeyValues:responseObject]];
         result(YES);
     } failure:^(NSError *error) {
         result(NO);
     }];
}


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
