//
//  YTAccountTool.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  账号工具类

#import "YTAccountTool.h"
#import "AFNetworking.h"
#import "NSDictionary+Extension.h"
#import "NSString+Password.h"
#import "SVProgressHUD.h"



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
 */
+ (YTAccount *)account
{
    YTAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:YTAccountPath];

    return account;
}


/**
 *  向服务器发起登录,获取token
 *
 */
+ (void)loginAccount:(YTAccount *)account result:(void (^)(BOOL result))result
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"] = account.userName;
    params[@"password"] = [NSString md5:account.password];
    
    // 2.发送一个POST请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTSession];

    [mgr POST:newUrl parameters:[NSDictionary httpWithDictionary:params]
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          // 保存账户信息
          account.userId = responseObject[@"userId"];
          account.token = responseObject[@"token"];
          [self save:account];
          result(YES);
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
          result(NO);
      }];
}

@end
