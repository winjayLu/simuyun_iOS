//
//  YTAccountTool.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  账号工具类

#import "YTAccountTool.h"
#import "YTAccount.h"


#define YTAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation YTAccountTool
/**
 *  存储帐号信息
 */
+ (void)save:(YTAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:YTAccountPath];
}

/**
 *  获得上次存储的帐号
 *
 *  @return 帐号过期, 返回nil
 */
+ (YTAccount *)account
{
#warning 测试阶段
//    YTAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:YTAccountPath];
    YTAccount *account = [[YTAccount alloc] init];
    return account;
}
@end
