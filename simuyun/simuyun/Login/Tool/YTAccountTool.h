//
//  YTAccountTool.h
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

// 帐号工具类

#import <Foundation/Foundation.h>
#import "YTAccount.h"

@class YTAccount;

@interface YTAccountTool : NSObject

/**
 *  存储帐号信息
 */
+ (void)save:(YTAccount *)account;

/**
 *  获得上次存储的帐号
 */
+ (YTAccount *)account;

/**
 *  向服务器发起登录,获取token
 *  成功返回YES
 */
+ (void)loginAccount:(YTAccount *)account result:(void (^)(BOOL result))result;
@end
