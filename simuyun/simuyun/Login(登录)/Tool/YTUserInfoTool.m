//
//  YTUserInfoTool.m
//  simuyun
//
//  Created by Luwinjay on 15/10/18.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 用户信息工具类

#import "YTUserInfoTool.h"
#import "YTAccountTool.h"


@implementation YTUserInfoTool

// 用户信息
static YTUserInfo *_userInfo;

/**
 *  获取上次存储的用户信息
 */
+ (YTUserInfo *)userInfo
{
    return _userInfo;
}
/**
 *  清除用户信息
 */
+ (void)clearUserInfo
{
    _userInfo = nil;
}
/**
 *  存储用户信息
 *
 */
+ (void)saveUserInfo:(YTUserInfo *)userInfo;
{
    _userInfo = userInfo;
}

/**
 *  重新获取最新的用户信息
 *
 */
+ (void)loadNewUserInfo:(void (^)(BOOL finally))finally
{
    // 去服务器获取
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"advisersId"] = [YTAccountTool account].userId;
    
    [YTHttpTool get:YTUser params:dict success:^(id responseObject) {
        [self saveUserInfo:[YTUserInfo objectWithKeyValues:responseObject]];
        finally(YES);
    } failure:^(NSError *error) {
        finally(NO);
    }];
}



@end
