//
//  AppDelegate.m
//  simuyun
//
//  Created by Luwinjay on 15/10/5.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "AppDelegate.h"
#import "YTTabBarController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "YTLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = DeviceBounds;
    
    //    // 设置根控制器
    //    if ([YTAccountTool account]) { // 登录过
    //        // 判断应用显示新特性还是欢迎界面
    //        [self.window chooseRootviewController:YES];
    //
    //    } else {
    //        // 显示登录界面
//            self.window.rootViewController = [[YTLoginViewController alloc] init];
    //    }
    
#warning 测试界面
    self.window.rootViewController = [[YTTabBarController alloc] init];
    
    
    /** 友盟分享及微信登录   */
    [self setupUmeng];
    
    /** 集成极光推送 */
    //    [self setupJpush:launchOptions];
    
    /** 检测版本跟新 */
//    [self newVersions];
    
    
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

/**
 *  检测新版本
 */
//- (void)newVersions
//{
//    //  http://www.site.com/interface/api?method=方法名&param={};
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"method"] = @"checkVersion";
//    dict[@"requesttype"] = @"";
//    dict[@"insver"] = @"3.000";
//    
//    [YTHttpTool get:YTServer params:[NSDictionary httpWithDictionary:dict] success:^(NSDictionary *responseObject) {
//        YTLog(@"%@",responseObject);
//        YTLog(@"ss");
//    } failure:^(NSError *error) {
//        NSLog(@"qq");
//        YTLog(@"%@",error);
//        YTLog(@"sserror");
//    }];
//    //https://intime.simuyun.com/api/interface/?method=checkVersion&param[insver]=0001&param[os]=ios-appstore
//    //result	__NSCFString *	@"https://182.92.217.186:6060/api/interface/api"	0x00007f9b862101d0
//}

///**
// *  接受到内存警告
// *
// */
//- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
//{
//    // 1.取消下载图片
//    [[SDWebImageManager sharedManager] cancelAll];
//    
//    // 2.清除图片缓存(内存缓存)
//    [[SDWebImageManager sharedManager].imageCache clearMemory];
//}
//
//- (void)applicationDidEnterBackground:(UIApplication *)application
//{
//    [application beginBackgroundTaskWithExpirationHandler:nil];
//}


/**
 *  友盟推送,统计相关
 *  微信登录
 */
- (void)setupUmeng
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppKey];
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAppID appSecret:WXAppSecret url:@"http://www.umeng.com/social"];
    
    /** 使用友盟统计  */
//    [MobClick startWithAppkey:UmengAppKey reportPolicy:BATCH  channelId:nil];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [MobClick setAppVersion:version];
    
    
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

@end
