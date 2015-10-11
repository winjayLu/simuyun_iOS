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

#define delay 3.0f

@interface YTWelcomeViewController ()

@end

@implementation YTWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YTRandomColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 获取程序主窗口
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        
        // 判断是否有登录过的账户
        if ([YTAccountTool account]) {
            mainWindow.rootViewController = [[YTTabBarController alloc] init];
        } else {
            mainWindow.rootViewController = [[YTLoginViewController alloc] init];
        }
        [mainWindow.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.75f];

    });
}
@end
