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
#import "YTAuthenticationErrorController.h"
#import "TCReportEngine.h"
#import "YTLoginViewController.h"
#import "YTRegisterViewController.h"
#import "YTResultPasswordViewController.h"
#import "YTProductdetailController.h"
#import "YTLoginViewController.h"
#import "YTRegisterViewController.h"
#import "YTResultPasswordViewController.h"
#import <RongIMKit/RongIMKit.h>



@interface AppDelegate ()
{
    NSTimer* _timer;
}
/**
 *  当前显示的控制器
 */
@property (nonatomic, strong) YTNavigationController *keyVc;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 获取程序启动信息
    [YTResourcesTool loadResourcesWithresult:^(BOOL result) {
        if (result == YES) {
            [YTCenter postNotificationName:YTResourcesSuccess object:nil];
        }
    }];
    
    // 检测是否有推送消息
    [self checkNotification:launchOptions];

    // 友盟分享及微信登录
    [self setupUmeng];

    // 集成极光推送
    [self setupJpush:launchOptions];
    
    // 开启腾讯云事件统计
    [[TCReportEngine sharedEngine] configAppId:TXAppKey];
    
    // 初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RongCloudKey];
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = DeviceBounds;
    // 设置窗口根控制器
    [self.window chooseRootviewController];
    [self.window makeKeyAndVisible];
    // 设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 清除提醒数字
    [YTJpushTool makeBadge];
    
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

/**
 *  常驻后台
 *
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    if([YTResourcesTool isVersionFlag] == YES){
        _timer =  [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(logAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        UIApplication*   app = [UIApplication sharedApplication];
        __block    UIBackgroundTaskIdentifier bgTask;
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid){
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid){
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        });
    }
}
-(void)logAction
{
    NSLog(@"常驻后台打印------------------------");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_timer invalidate];
    _timer = nil;
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

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}



- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
        
        /**
         * 统计推送打开率2
         */
        [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    } else {
        NSLog(@"该远程推送不包含来自融云的推送服务");
        [self receivedPushNotification:userInfo];
        [APService handleRemoteNotification:userInfo];
    }
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
//{
//    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
//    if (pushServiceData) {
//        NSLog(@"该远程推送包含来自融云的推送服务");
//        for (id key in [pushServiceData allKeys]) {
//            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
//        }
//        
//        /**
//         * 统计推送打开率2
//         */
//        [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
//    } else {
//        [self receivedPushNotification:userInfo];
//        // iOS7
//        [APService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UIBackgroundFetchResultNewData);
//}

/**
 *  检测是否有推送消息
 *  自动跳转
 */
- (void)checkNotification:(NSDictionary *)launchOptions
{
    /**
     * 获取融云推送服务扩展字段1
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromLaunchOptions:launchOptions];
    if (pushServiceData) {
        NSLog(@"该启动事件包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"%@", pushServiceData[key]);
        }
    } else {
        NSLog(@"该启动事件不包含来自融云的推送服务");
        NSDictionary* remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if(remoteNotification)
        {
            YTJpushModel *jpush = [YTJpushModel objectWithKeyValues:remoteNotification];
            [YTJpushTool saveJpush:jpush];
        }
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
    // 过滤旧版本推送消息
    if (jpush == nil || jpush.title.length == 0 || jpush.detail.length == 0) return;
    [YTJpushTool makeBadge];
    if (jpush.type == 5)    // 认证成功
    {
        [self authenticationSuccess:jpush];
    } else if (jpush.type == 6) // 认证失败
    {
        [self authenticationError:jpush];
    } else if (jpush.type == 4) // 产品发行
    {
        [self newProduct:jpush];
    }  else {    // h5页面跳转
        [self jumpToHtml:jpush];
    }
}

/**
 *  获取当前正在显示的控制器
 *
 */
- (void)keyViewController:(YTJpushModel *)jpush
{
    // 获取根控制器
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    // 如果获取不到直接返回
    if (keyWindow == nil) return;
    
    UIViewController *appRootVC = keyWindow.rootViewController;
    // 欢迎/登录/注册  不弹出推送弹出框
    if ([appRootVC isKindOfClass:[YTNavigationController class]])
    {
        UIViewController *rootVc = ((YTNavigationController *)appRootVC).topViewController;
        if ([rootVc isKindOfClass:[YTWelcomeViewController class]]|| [rootVc isKindOfClass:[YTLoginViewController class]] || [rootVc isKindOfClass:[YTRegisterViewController class]] || [rootVc isKindOfClass:[YTResultPasswordViewController class]])
        {
            self.keyVc = nil;
            [YTJpushTool saveJpush:jpush];
            return;
        }
    } else if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        UIViewController *keyVc = ((UITabBarController *)appRootVC).selectedViewController;
        if (keyVc != nil) {
            self.keyVc = (YTNavigationController *)keyVc;
        }
    }
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

#pragma mark - 推送通知处理
/**
 *  理财师认证成功
 */
- (void)authenticationSuccess:(YTJpushModel *)jpush
{
    HHAlertView *alert = [HHAlertView shared];
    NSString *cancelButton = nil;
    NSString *okButton = @"知道了";
    // 获取正在显示的控制器
    [self keyViewController:jpush];
    if (self.keyVc == nil) return;
    if (self.keyVc.viewControllers.count == 1) {
        cancelButton = @"知道了";
        okButton = @"产品中心";
    }
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:jpush.title detail:jpush.detail cancelButton:cancelButton Okbutton:okButton block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            if ([okButton isEqualToString:@"产品中心"]) {
                // 获取根控制器
                UIWindow *keyWindow = nil;
                for (UIWindow *window in [UIApplication sharedApplication].windows) {
                    if (window.windowLevel == 0) {
                        keyWindow = window;
                        break;
                    }
                }
                // 如果获取不到直接返回
                if (keyWindow == nil) return;
                
                UIViewController *appRootVC = keyWindow.rootViewController;
                if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
                    ((YTTabBarController *)appRootVC).selectedIndex = 1;
                }
            }
            [YTJpushTool saveJpush:nil];
        } else {
            [YTJpushTool saveJpush:nil];
        }
    }];
}

/**
 *  理财师认证失败
 */
- (void)authenticationError:(YTJpushModel *)jpush
{
    // 获取当前控制器
    // 获取正在显示的控制器
    [self keyViewController:jpush];
    if (self.keyVc == nil) return;
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:jpush.title detail:jpush.detail cancelButton:@"返回" Okbutton:@"重新认证" block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            // 需要跳转的控制器
            YTAuthenticationErrorController *authenError = [[YTAuthenticationErrorController alloc] init];
            authenError.hidesBottomBarWhenPushed = YES;
            [self.keyVc pushViewController:authenError animated:YES];
            [YTJpushTool saveJpush:nil];
        } else {
            [YTJpushTool saveJpush:nil];
        }
    }];
}

/**
 *  新产品发行
 */
- (void)newProduct:(YTJpushModel *)jpush
{
    // 获取正在显示的控制器
    [self keyViewController:jpush];
    if (self.keyVc == nil) return;
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:jpush.title detail:jpush.detail cancelButton:@"返回" Okbutton:@"查看详情" block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            YTProductdetailController *web = [[YTProductdetailController alloc] init];
            web.url = [NSString stringWithFormat:@"%@%@", YTH5Server, jpush.jumpUrl];
            // 获取产品id
            NSRange range = [jpush.jumpUrl rangeOfString:@"id="];
            web.proId = [jpush.jumpUrl substringFromIndex:range.location + range.length];
            web.hidesBottomBarWhenPushed = YES;
            [self.keyVc pushViewController:web animated:YES];
            [YTJpushTool saveJpush:nil];
        } else {
            [YTJpushTool saveJpush:nil];
        }
    }];
}
/**
 *  h5页面跳转
 */
- (void)jumpToHtml:(YTJpushModel *)jpush
{
    // 获取正在显示的控制器
    [self keyViewController:jpush];
    if (self.keyVc == nil) return;
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:jpush.title detail:jpush.detail cancelButton:@"返回" Okbutton:@"查看详情" block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            // 需要跳转的控制器
            YTNormalWebController *webVc = [YTNormalWebController webWithTitle:jpush.title url:[NSString stringWithFormat:@"%@%@",YTH5Server, jpush.jumpUrl]];
            webVc.isDate = YES;
            webVc.hidesBottomBarWhenPushed = YES;
            [self.keyVc pushViewController:webVc animated:YES];
            [YTJpushTool saveJpush:nil];
        } else {
            [YTJpushTool saveJpush:nil];
        }
    }];
}

@end
