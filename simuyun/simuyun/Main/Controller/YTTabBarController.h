//
//  YTTabBarController.h
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  主控制器

#import <UIKit/UIKit.h>
#import "CustomMaskViewController.h"
#import "FloatView.h"

@interface YTTabBarController : UITabBarController

/**
 *  视频控制器
 */
@property (nonatomic, strong) CustomMaskViewController *playerVc;

/**
 *  浮动的按钮
 */
@property (nonatomic, strong) FloatView *floatView;

@end
