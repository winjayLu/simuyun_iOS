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

#define YTUserInfoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.data"]

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
    if (_userInfo.iconImage != nil) {
        userInfo.iconImage = _userInfo.iconImage;
        _userInfo = userInfo;
    } else {
        _userInfo = userInfo;
    }
    
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
        YTUserInfo *userInfo = [YTUserInfo objectWithKeyValues:responseObject];
        [self saveUserInfo:userInfo];
        [self localsave:userInfo];
        finally(YES);
    } failure:^(NSError *error) {
        finally(NO);
    }];
}

#pragma mark - 本地存储
/**
 *  本地存储用户信息
 */
+ (void)localsave:(YTUserInfo *)userInfo
{
    [NSKeyedArchiver archiveRootObject:userInfo toFile:YTUserInfoPath];
}

/**
 *  获取本地用户信息
 */
+ (YTUserInfo *)localUserInfo
{
    YTUserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:YTUserInfoPath];
    userInfo.isSingIn = 1;
    _userInfo = userInfo;
    return userInfo;
}



@end
