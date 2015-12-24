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
#import "HHAlertView.h"
#import "YTJpushModel.h"
#import "YTTabBarController.h"
#import "YTNormalWebController.h"
#import "YTNavigationController.h"
#import "YTJpushTool.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 清空数字
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 获取程序启动信息
    [YTResourcesTool loadResourcesWithresult:^(BOOL result) {}];
    
    // 检测是否有推送消息
    [self checkNotification:launchOptions];

    // 友盟分享及微信登录
    [self setupUmeng];

    // 集成极光推送
    [self setupJpush:launchOptions];
    
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
- (void)setupUmeng
{
    // 设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppKey];
    // 设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAppID appSecret:WXAppSecret url:@"http://www.umeng.com/social"];
    
    // 友盟统计
    [MobClick startWithAppkey:UmengAppKey reportPolicy:BATCH  channelId:nil];
    // 获取版本号
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
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
    [APService setLogOFF];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self receivedPushNotification:userInfo];
    [APService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [self receivedPushNotification:userInfo];
    // iOS7
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

/**
 *  检测是否有推送消息
 *  自动跳转
 */
- (void)checkNotification:(NSDictionary *)launchOptions
{
    NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    YTJpushModel *jpush = [YTJpushModel objectWithKeyValues:remoteNotification];
    [YTJpushTool saveJpush:jpush];
    if (remoteNotification) {
        [YTJpushTool saveTest:remoteNotification];
    }
}

/**
 *  程序内收到推送消息
 *
 */
- (void)receivedPushNotification:(NSDictionary *)userInfo
{
    if ([YTJpushTool jpush]) return;
    YTJpushModel *jpush = [YTJpushModel objectWithKeyValues:userInfo];
    if (jpush == nil || jpush.jumpUrl == nil || jpush.jumpUrl.length == 0) return;

    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:jpush.title detail:jpush.detail cancelButton:@"返回" Okbutton:@"查看详情" block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 需要跳转的控制器
                
                YTNormalWebController *webVc = [YTNormalWebController webWithTitle:jpush.title url:[NSString stringWithFormat:@"%@%@",YTH5Server, jpush.jumpUrl]];
                webVc.hidesBottomBarWhenPushed = YES;
                // 获取当前控制器
                YTNavigationController *keyVc = [self keyViewController];
                [keyVc pushViewController:webVc animated:YES];
            });
        }
    }];
}

/**
 *  获取当前正在显示的控制器
 *
 */
- (YTNavigationController *)keyViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        UIViewController *keyVc = ((UITabBarController *)appRootVC).selectedViewController;
        return (YTNavigationController *)keyVc;
    }
    return nil;
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
