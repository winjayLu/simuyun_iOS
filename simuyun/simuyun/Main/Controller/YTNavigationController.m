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
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor yellowColor]] forBarMetrics:UIBarMetricsDefault];
    
    // 反回按钮的颜色
    [navBar setTintColor:[UIColor blackColor]];
    // 设置状态栏背景
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    // 设置导航栏的文字
    [navBar setTitleTextAttributes:@{
                                     
                                     NSForegroundColorAttributeName : [UIColor redColor]
                                     }];
    
    // 导航栏上面的item
    UIBarButtonItem *barItem =[UIBarButtonItem appearance];
    // 设置背景
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_disable.png"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    // 设置item的文字属性
    NSDictionary *barItemTextAttr = @{
                                      NSForegroundColorAttributeName : [UIColor purpleColor]
                                      };
    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateNormal];  
    [barItem setTitleTextAttributes:barItemTextAttr forState:UIControlStateHighlighted];
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
