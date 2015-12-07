//
//  YTUserInfoTool.h
//  simuyun
//
//  Created by Luwinjay on 15/10/18.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 用户信息工具类

#import <Foundation/Foundation.h>
#import "YTUserInfo.h"

@interface YTUserInfoTool : NSObject


/**
 *  获取上次存储的用户信息
 */
+ (YTUserInfo *)userInfo;

/**
 *  存储用户信息
 *
 */
+ (void)saveUserInfo:(YTUserInfo *)userInfo;

/**
 *  清除用户信息
 */
+ (void)clearUserInfo;


/**
 *  重新获取最新的用户信息
 *
 */
+ (void)loadNewUserInfo:(void (^)(BOOL finally))finally;



@end
