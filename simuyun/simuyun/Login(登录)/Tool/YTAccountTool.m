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
#import "APService.h"
#import "YTLoginViewController.h"
#import "CALayer+Anim.h"
#import "CALayer+Transition.h"
#import "YTUserInfoTool.h"
#import "CoreArchive.h"


#define YTAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

@implementation YTAccountTool
/**
 *  存储帐号信息
 */
+ (void)save:(YTAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:YTAccountPath];
    if (account != nil) {
        [CoreArchive setStr:account.userName key:@"userName"];
    }
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
    params[@"password"] = account.password;
    
    // 2.发送一个POST请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTSession];
    YTLog(@"%@", newUrl);
    YTLog(@"%@", params);
    [mgr POST:newUrl parameters:[NSDictionary httpWithDictionary:params]
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          // 保存账户信息
          account.password = params[@"password"];
          account.userId = responseObject[@"userId"];
          account.token = responseObject[@"token"];
          [self save:account];
          [APService setAlias:account.userId callbackSelector:nil object:nil];
          
          [YTUserInfoTool loadNewUserInfo:^(BOOL finally) {
              if (finally) {
                  result(YES);
              }
          }];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if(operation.responseObject[@"message"] != nil)
          {
              if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                  [YTHttpTool tokenError];
              } else {
                  [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
              }
          }else if(error.userInfo[@"NSLocalizedDescription"] != nil)
          {
              [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
          } else {
              [SVProgressHUD showErrorWithStatus:@"登录失败"];
          }
          result(NO);
      }];
}




@end
