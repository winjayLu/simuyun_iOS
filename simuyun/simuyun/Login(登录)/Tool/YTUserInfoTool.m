//
//  YTUserInfoTool.m
//  simuyun
//
//  Created by Luwinjay on 15/10/18.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 用户信息工具类

#import "YTUserInfoTool.h"

@implementation YTUserInfoTool

// 用户信息
static YTUserInfo *_userInfo;

+ (YTUserInfo *)loadUserInfo
{
    // 已经有用户信息,直接返回
    if (_userInfo) return _userInfo;
    
    // 去服务器获取
    YTUserInfo *userinfo = [[YTUserInfo alloc] init];
    userinfo.nickName = @"winjay";
    _userInfo = userinfo;
  
    return _userInfo;
}

@end
