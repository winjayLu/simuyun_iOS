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
#import "CoreNewFeatureVC.h"
#import "CALayer+Transition.h"
#import "UIImage+Extend.h"

@implementation UIWindow (Extension)

/**
 *  选择根控制器
 */
- (void)chooseRootviewController
{
    
    
    // 判断显示新特性还是欢迎界面
    if ([CoreNewFeatureVC canShowNewFeature])
    {
        NSString *imageName = @"newFeature";
        if (iPhone6) {
            imageName = @"newFeatureiphone6";
        } else if(iPhone5)
        {
            imageName = @"newFeatureiphone5";
        }
        
        // 创建性特性模型
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageNamed:[NSString stringWithFormat:@"%@1",imageName]]];
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageNamed:[NSString stringWithFormat:@"%@2",imageName]]];
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageNamed:[NSString stringWithFormat:@"%@3",imageName]]];
        NewFeatureModel *m4 = [NewFeatureModel model:[UIImage imageNamed:[NSString stringWithFormat:@"%@4",imageName]]];
        NewFeatureModel *m5 = [NewFeatureModel model:[UIImage imageNamed:[NSString stringWithFormat:@"%@5",imageName]]];
        
        // 新特性控制器
        self.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3,m4,m5] enterBlock:^{
            // 登录控制器
            self.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
//            [self transitionVc];
        }];
    } else {
        // 欢迎控制器
        self.rootViewController = [[YTWelcomeViewController alloc] init];
    }
}

/**
 *  转场
 */
-(void)transitionVc{
    [self.layer transitionWithAnimType:TransitionAnimTypePageCurl subType:TransitionSubtypesFromBotoom curve:TransitionCurveEaseIn duration:1.0f];
}


@end
