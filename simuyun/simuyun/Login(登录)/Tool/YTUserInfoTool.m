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
 *  加载用户信息
 *  成功返回YES
 */
+ (void)loadUserInfoWithresult:(void (^)(BOOL result))result
{
//     已经有用户信息,直接返回
    if (_userInfo) {
        result(YES);
        return;
    }
    
    // 去服务器获取
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"advisersId"] = [YTAccountTool account].userId;
    
    [YTHttpTool get:YTUser params:dict success:^(id responseObject) {
        _userInfo = [YTUserInfo objectWithKeyValues:responseObject];
        result(YES);
    } failure:^(NSError *error) {
        result(NO);
    }];

}


/**
 *  重新获取最新的用户信息
 *
 */
+ (void)loadNewUserInfo:(void (^)(BOOL result))result
{
    // 去服务器获取
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"advisersId"] = [YTAccountTool account].userId;
    
    [YTHttpTool get:YTUser params:dict success:^(id responseObject) {
        _userInfo = [YTUserInfo objectWithKeyValues:responseObject];
        result(YES);
    } failure:^(NSError *error) {
        result(NO);
    }];
}

@end
