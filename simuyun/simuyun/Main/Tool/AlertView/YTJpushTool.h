//
//  YTJpushTool.h
//  simuyun
//
//  Created by Luwinjay on 15/11/26.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 极光推送工具类
#import <Foundation/Foundation.h>
#import "YTJpushModel.h"

@interface YTJpushTool : NSObject

/**
 *  修改BadgeNumber   减一
 *
 */
- (void)makeBadge;
/**
 *  存储启动信息
 */
+ (void)saveJpush:(YTJpushModel *)jpush;


/**
 *  获取上次存储的启动信息
 */
+ (YTJpushModel *)jpush;



+ (NSDictionary *)test;

+ (void)saveTest:(NSDictionary *)test;

@end
