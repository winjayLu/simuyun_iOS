//
//  UIWindow+Extension.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "YTNewfeatureViewController.h"
#import "YTWelcomeViewController.h"
#import "YTTabBarController.h"

@implementation UIWindow (Extension)

/**
 *  选择根控制器
 */
- (void)chooseRootviewController
{
    
    
    // 判断应用显示新特性还是欢迎界面
    NSString *sandboxVersion = nil;
    
    // 2.获取软件当前的版本号
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = dict[@"CFBundleShortVersionString"];
    
    // 3.服务器的版本号和软件当前的版本号
    if([currentVersion compare:sandboxVersion] == NSOrderedDescending )
    {
        // 显示新特性
        self.rootViewController = [[YTNewfeatureViewController alloc] init];
    }else
    {
        // 显示欢迎界面
//        if(isWelcome)
        {
            self.rootViewController = [[YTWelcomeViewController alloc] init];
        }
//        else
        {
            self.rootViewController = [[YTTabBarController alloc] init];
        }
    }
}
@end
