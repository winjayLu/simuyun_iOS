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

@interface AppDelegate ()

/**
 *  当前显示的控制器
 */
@property (nonatomic, strong) YTNavigationController *keyVc;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // 清空数字
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 获取程序启动信息
    [YTResourcesTool loadResourcesWithresult:^(BOOL result) {
        if (result == YES) {
            [YTCenter postNotificationName:YTResourcesSuccess object:nil];
        } else {
            [YTCenter postNotificationName:YTResourcesError object:nil];
        }
    }];
    
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
    if (jpush == nil) return;

    if (jpush.type == 5)    // 认证成功
    {
        [self authenticationSuccess:jpush];
    } else if (jpush.type == 6) // 认证失败
    {
        [self authenticationError:jpush];
    } else {    // h5页面跳转
        [self jumpToHtml:jpush];
    }
}

/**
 *  获取当前正在显示的控制器
 *
 */
- (void)keyViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
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
    UIViewController *rootVc =  [UIApplication sharedApplication].keyWindow.rootViewController;
    // 获取正在显示的控制器
    [self keyViewController];
    if (self.keyVc.viewControllers.count == 1) {
        cancelButton = @"知道了";
        okButton = @"认购产品";
    }
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:jpush.title detail:jpush.detail cancelButton:cancelButton Okbutton:okButton block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            if ([okButton isEqualToString:@"认购产品"]) {
                ((YTTabBarController *)rootVc).selectedIndex = 1;
            }
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
    [self keyViewController];
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:jpush.title detail:jpush.detail cancelButton:@"返回" Okbutton:@"重新认证" block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            // 需要跳转的控制器
            YTAuthenticationErrorController *authenError = [[YTAuthenticationErrorController alloc] init];
            authenError.hidesBottomBarWhenPushed = YES;
            [self.keyVc pushViewController:authenError animated:YES];
        }
    }];
}
/**
 *  h5页面跳转
 */
- (void)jumpToHtml:(YTJpushModel *)jpush
{
    // 获取正在显示的控制器
    [self keyViewController];
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:jpush.title detail:jpush.detail cancelButton:@"返回" Okbutton:@"查看详情" block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            // 需要跳转的控制器
            YTNormalWebController *webVc = [YTNormalWebController webWithTitle:jpush.title url:[NSString stringWithFormat:@"%@%@",YTH5Server, jpush.jumpUrl]];
            webVc.isDate = YES;
            webVc.hidesBottomBarWhenPushed = YES;
            [self.keyVc pushViewController:webVc animated:YES];
        }
    }];
}

@end
