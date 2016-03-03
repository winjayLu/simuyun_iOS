//
//  WJHttpTool.m
//
//  Created by apple on 14/12/25.
//  Copyright (c) 2014年 winjay. All rights reserved.
//
//  网络请求工具类

#import "YTHttpTool.h"
#import "AFNetworking.h"
#import "NSDictionary+Extension.h"
#import "SVProgressHUD.h"
#import "YTAccountTool.h"
#import "HHAlertView.h"
#import "YTNavigationController.h"
#import "YTLoginViewController.h"
#import "YTUserInfoTool.h"

@implementation YTHttpTool
/**
 *  post请求
 *
 */
+ (void)post:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个POST请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, url];
//    NSLog(@"%@", newUrl);
//    NSLog(@"%@", [NSDictionary httpWithDictionary:params]);
    [mgr POST:newUrl parameters:[NSDictionary httpWithDictionary:params]
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if(operation.responseObject[@"message"] != nil)
          {
              if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                  [YTHttpTool tokenError];
              } else {
                  [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
              }
          } else if(error.userInfo[@"NSLocalizedDescription"] != nil)
          {
              [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
          } else {
              [SVProgressHUD dismiss];
          }
          if (failure) {
              failure(error);
          }
    }];

}
/**
 *  get请求
 *
 */
+ (void)get:(NSString *)url params:(id)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];

    // 2.发送一个GET请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, url];
    [mgr GET:newUrl parameters:[NSDictionary httpWithDictionary:params]
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if(operation.responseObject[@"message"] != nil)
          {
              if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                  [YTHttpTool tokenError];
              } else {
                  [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
              }
          } else {
              [SVProgressHUD dismiss];
          }
          if (failure) {
              failure(error);
          }
      }];
}

/**
 *  文件上传
 *
 */
+ (void)post:(NSString *)url params:(id)params files:(NSArray *)files success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // 2.发送请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, url];
    
    [manager POST:newUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传文件设置
        for (YTHttpFile *file in files) {
            NSLog(@"%@", file);
            [formData appendPartWithFileData:file.data name:file.name fileName:file.filename mimeType:file.mimeType];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(operation.responseObject[@"message"] != nil)
        {
            if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                [self tokenError];
            } else {
                [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
            }
        } else if(error.userInfo[@"NSLocalizedDescription"] != nil)
        {
            [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
        }
        if (failure) {
            failure(error);
        }
    }];
}


/**
 *  token错误重新登录
 */
+ (void)tokenError
{
//    [YTCenter postNotificationName:YTStopRequest object:nil];
//    HHAlertView *alert = [HHAlertView shared];
//    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:YTTokenError detail:YTTokenErrorContent cancelButton:nil Okbutton:@"知道了" block:^(HHAlertButton buttonindex) {
//        // 清除用户信息
//        [YTUserInfoTool clearUserInfo];
//        // 获取程序主窗口
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 获取根控制器
//            UIWindow *keyWindow = nil;
//            for (UIWindow *window in [UIApplication sharedApplication].windows) {
//                if (window.windowLevel == 0) {
//                    keyWindow = window;
//                    break;
//                }
//            }
//            // 如果获取不到直接返回
//            if (keyWindow == nil) return;
//            keyWindow.rootViewController = [[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
//        });
//    }];
}



@end

@implementation YTHttpFile

+ (instancetype)fileWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType filename:(NSString *)filename
{
    YTHttpFile *file = [[self alloc] init];
    file.name = name;
    file.data = data;
    file.mimeType = mimeType;
    file.filename = filename;
    return file;
}
@end
