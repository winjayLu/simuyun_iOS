//
//  YTNavigationController.m
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import "YTNavigationController.h"
#import "UIImage+Extend.h"

@interface YTNavigationController ()

@end

@implementation YTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置导航栏背景
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
    
    // 反回按钮的颜色
    [navBar setTintColor:[UIColor whiteColor]];
    // 设置状态栏背景
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    // 设置导航栏的文字
    [navBar setTitleTextAttributes:@{
                                     
                                     NSForegroundColorAttributeName : [UIColor whiteColor]
                                     }];
    
    // 导航栏上面的item
    UIBarButtonItem *barItem =[UIBarButtonItem appearance];
    // 设置背景
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_disable.png"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    // 设置item的文字属性
    NSDictionary *barItemTextAttr = @{
                                      NSForegroundColorAttributeName : [UIColor whiteColor]
                                      };
    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateNormal];  
    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateHighlighted];
    // 去掉 backButton 的文字
    [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




@end
