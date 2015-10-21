//
//  YTResourcesTool.h
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTResources.h"

@interface YTResourcesTool : NSObject


/**
 *  获取上次存储的启动信息
 */
+ (YTResources *)resources;

/**
 *  存储启动信息
 */
+ (void)saveResources:(YTResources *)resources;

@end
