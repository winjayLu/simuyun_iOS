//
//  YTMessageNumTool.h
//  simuyun
//
//  Created by Luwinjay on 15/11/2.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTMessageNum.h"

// 消息模块工具类

@interface YTMessageNumTool : NSObject

/**
 *  存储未读消息数量
 */
+ (void)save:(YTMessageNum *)messageNum;

/**
 *  获得上次存储的未读消息数量
 */
+ (YTMessageNum *)messageNum;

@end
