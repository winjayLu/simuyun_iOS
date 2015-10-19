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


#define delay 3.0f

@interface YTWelcomeViewController ()

@end

@implementation YTWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 下载banner图片
    
    
    
    // 获取用户信息
    if ([YTAccountTool account]) {
        [YTUserInfoTool loadUserInfo];
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
            mainWindow.rootViewController = [[YTTabBarController alloc] init];
        } else {
            mainWindow.rootViewController = [[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
        }
        [mainWindow.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
        
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
