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
    
    if (iPhone6) {
        YTLog(@"加载iphoe6对应的图片");
    }
    // 判断显示新特性还是欢迎界面
    if ([CoreNewFeatureVC canShowNewFeature])
    {
        // 创建性特性模型
        NewFeatureModel *m1 = [NewFeatureModel model:[UIImage imageWithColor:YTRandomColor]];
        NewFeatureModel *m2 = [NewFeatureModel model:[UIImage imageWithColor:YTRandomColor]];
        NewFeatureModel *m3 = [NewFeatureModel model:[UIImage imageWithColor:YTRandomColor]];
        
        // 新特性控制器
        self.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3] enterBlock:^{
            self.rootViewController = [[YTLoginViewController alloc] init];
            [self transitionVc];
        }];
    } else {
        // 欢迎控制器
        self.rootViewController = [[YTWelcomeViewController alloc] init];
    }
    
#warning 开发阶段
//    self.rootViewController = [[YTTabBarController alloc] init];
}

/**
 *  转场
 */
-(void)transitionVc{
    [self.layer transitionWithAnimType:TransitionAnimTypePageCurl subType:TransitionSubtypesFromBotoom curve:TransitionCurveEaseIn duration:1.0f];
}


@end
