//
//  YTResourcesTool.h
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTResources.h"

// 程序资源信息工具类


@interface YTResourcesTool : NSObject


/**
 *  加载程序启动信息
 */
+ (void)loadResourcesWithresult:(void (^)(BOOL result))result;


/**
 *  获取上次存储的启动信息
 */
+ (YTResources *)resources;

/**
 *  存储启动信息
 */
+ (void)saveResources:(YTResources *)resources;

/**
 *  思路:收到服务器显示,本地持久化,新特性时清除本地数据
 封装方法,返回bool,是否可以显示
 */
/**
 *  是否可以显示,一些功能
 *
 *  @return YES可以显示,NO不可以显示
 */
+ (BOOL)isVersionFlag;



@end
