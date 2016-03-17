//
//  UIWindow+Extension.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "YTWelcomeViewController.h"
#import "YTTabBarController.h"
#import "YTLoginViewController.h"
#import "XZMCoreNewFeatureVC.h"
#import "CALayer+Transition.h"
#import "UIImage+Extend.h"
#import "CoreArchive.h"
#import "YTAccountTool.h"
#import "YTNavigationController.h"
#import "SVProgressHUD.h"

@implementation UIWindow (Extension)

/**
 *  选择根控制器
 */
- (void)chooseRootviewController
{
    BOOL canShow = [XZMCoreNewFeatureVC canShowNewFeature];
    canShow = YES;
    // 判断显示新特性还是欢迎界面
    if (canShow)
    {
        // 重新打开AppStore开关
        [CoreArchive setStr:nil key:@"versionFlag"];
        
        NSString *imageName = @"newFeature";
        if (iPhone6) {
            imageName = @"newFeatureiphone6";
        } else if(iPhone5)
        {
            imageName = @"newFeatureiphone5";
        }
        
        
        self.rootViewController = [XZMCoreNewFeatureVC newFeatureVCWithImageNames:@[[NSString stringWithFormat:@"%@1.jpg",imageName],[NSString stringWithFormat:@"%@2.jpg",imageName]]
        enterBlock:^{
            // 判断是否有登录过的账户
            if ([YTAccountTool account]) {
                // 发起登录
                [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
                if ([YTAccountTool account]) {
                    [YTAccountTool loginAccount:[YTAccountTool account] result:^(BOOL result) {
                        if (result) {
                            [SVProgressHUD dismiss];
                            self.rootViewController = [[YTTabBarController alloc] init];
                        } else {
                            [SVProgressHUD showErrorWithStatus:@"登录失败"];
                            self.rootViewController = [[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
                        }
                        [self.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
                    }];
                }
            } else {
                
                // 登录控制器
                self.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
                [self.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
            }
            
        } configuration:^(UIButton *enterButton) { // 配置进入按钮
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
            [enterButton setBackgroundImage:[UIImage imageNamed:@"btn_pressed"] forState:UIControlStateHighlighted];
            enterButton.bounds = CGRectMake(0, 0, 120, 40);
            enterButton.center = CGPointMake(KScreenW * 0.5, KScreenH* 0.85);
        }];

    } else {
        // 欢迎控制器
        self.rootViewController = [[YTWelcomeViewController alloc] init];
    }
}

/**
 *  转场
 */
//-(void)transitionVc{
//    [self.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.75f];
//}


@end
