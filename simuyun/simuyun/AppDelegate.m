//
//  AppDelegate.m
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright © 2015年 YTWealth. All rights reserved.
//


#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "YTLoginViewController.h"
#import "SDWebImageManager.h"
#import "MobClick.h"
#import "APService.h"
#import "YTWelcomeViewController.h"
#import "UIWindow+Extension.h"
#import "YTResourcesTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 获取版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    // 友盟分享及微信登录
    [self setupUmeng:version];
    
    // 集成极光推送
    [self setupJpush:launchOptions];
    
    // 检测是否有推送消息
    [self checkNotification:launchOptions];
    
    // 获取程序启动信息
    [self resources:version];
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = DeviceBounds;
    // 设置窗口根控制器
    [self.window chooseRootviewController];
    // 设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 友盟社会化组件
/**
 *  初始化友盟推送-微信登录
 *
 */
- (void)setupUmeng:(NSString *)version
{
    // 设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppKey];
    // 设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAppID appSecret:WXAppSecret url:@"http://www.umeng.com/social"];
    
    // 友盟统计
    [MobClick startWithAppkey:UmengAppKey reportPolicy:BATCH  channelId:nil];
    [MobClick setAppVersion:version];
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

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [application beginBackgroundTaskWithExpirationHandler:nil];
}



#pragma mark - 极光推送
/**
 *  初始化极光推送
 *
 */
- (void)setupJpush:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
    
    [APService setupWithOption:launchOptions];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%zd], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);
    
    
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // iOS7
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

/**
 *  检测是否有推送消息
 */
- (void)checkNotification:(NSDictionary *)launchOptions
{
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
}

/**
 *  获取程序启动信息
 */
- (void)resources:(NSString *)version
{

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"os"] = @"ios-appstore";
    dict[@"version"] = version;

    [YTHttpTool get:YTGetResources params:dict success:^(NSDictionary *responseObject)
    {
        [YTResourcesTool saveResources:[YTResources objectWithKeyValues:responseObject]];
    } failure:^(NSError *error) {
    }];

}

/**
 *  接受到内存警告
 *
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 1.取消下载图片
    [[SDWebImageManager sharedManager] cancelAll];

    // 2.清除图片缓存(内存缓存)
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end
