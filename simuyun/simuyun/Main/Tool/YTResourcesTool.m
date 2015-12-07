//
//  YTResourcesTool.m
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTResourcesTool.h"
#import "CoreArchive.h"

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
    if (resources.versionFlag == 1) {
        [CoreArchive setStr:@"YES" key:@"versionFlag"];
    }
}

/**
 *  思路:收到服务器显示,本地持久化,新特性时清除本地数据
    封装方法,返回bool,是否可以显示
 */
/**
 *  是否可以显示,一些功能
 *
 *  @return YES可以显示,NO不可以显示
 */
+ (BOOL)isVersionFlag
{
    NSString *versionFlag = [CoreArchive strForKey:@"versionFlag"];
    if (versionFlag.length > 0) {
        return  YES;
    }
    return NO;
}


@end
