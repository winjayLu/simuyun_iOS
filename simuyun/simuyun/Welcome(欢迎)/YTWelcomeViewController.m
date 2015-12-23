//
//  YTWelcomeViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  欢迎界面

#import "YTWelcomeViewController.h"
#import "YTLoginViewController.h"
#import "YTTabBarController.h"
#import "YTAccountTool.h"
#import "CALayer+Transition.h"
#import "YTNavigationController.h"
#import "YTUserInfoTool.h"
#import "YTResourcesTool.h"
#import "UIImageView+SD.h"

#define delay 3.0f

@interface YTWelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@end

@implementation YTWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 下载banner图片
    YTResources *resources = [YTResourcesTool resources];
    if (resources) {  // 已经获取到了
        [self.bannerImage imageWithUrlStr:resources.appWelcomeImg phImage:nil];
    } else
    {
        // 重新获取
        [YTResourcesTool loadResourcesWithresult:^(BOOL result) {
            if (result) {
                [self.bannerImage imageWithUrlStr:[YTResourcesTool resources].appWelcomeImg phImage:nil];
            }
        }];
    }
    // 转场
    [self transitionMainVC];
}

- (void)transitionMainVC
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 获取程序主窗口
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        // 判断是否有登录过的账户
        if ([YTAccountTool account]) {
            // 发起登录
            if ([YTAccountTool account]) {
                [YTAccountTool loginAccount:[YTAccountTool account] result:^(BOOL result) {
                    if (result) {
                        mainWindow.rootViewController = [[YTTabBarController alloc] init];
                    } else {
                        mainWindow.rootViewController = [[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
                    }
                    [mainWindow.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
                }];
            }
        } else {
            mainWindow.rootViewController = [[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
            [mainWindow.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
        }
    });
}

#pragma mark - 准备数据



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
