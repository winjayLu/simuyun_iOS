//
//  YTHomeViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import "YTHomeViewController.h"
#import "YTProfileTopView.h"
#import "UIImage+Extend.h"

@interface YTHomeViewController () <iconPhotoDelegate, UINavigationControllerDelegate>


@end

@implementation YTHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = YTColor(255, 255, 255);
//    self.title = @"我";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /*
     UIBarMetricsDefault,
     UIBarMetricsCompact,
     UIBarMetricsDefaultPrompt = 101, // Applicable only in bars with the prompt property, such as UINavigationBar and UISearchBar
     UIBarMetricsCompactPrompt,
     
     UIBarMetricsLandscapePhone NS_ENUM_DEPRECATED_IOS(5_0, 8_0, "Use UIBarMetricsCompact instead") = UIBarMetricsCompact,
     UIBarMetricsLandscapePhonePrompt NS_ENUM_DEPRECATED_IOS(7_0, 8_0, "Use UIBarMetricsCompactPrompt") = UIBarMetricsCompactPrompt,
     
     */
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar setBackgroundImage:[UIImage imageWithColor:YTColor(255, 255, 255)] forBarMetrics:UIBarMetricsDefault];
//    self.extendedLayoutIncludesOpaqueBars = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//        　　self.edgesForExtendedLayout = UIRectEdgeNone;
//        　}
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    
//    [bar setValue:@(0) forKeyPath:@"backgroundView.alpha"];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    // 设置导航栏背景
    [navBar setBackgroundImage:[UIImage imageWithColor:YTColor(255, 255, 255)]forBarMetrics:UIBarMetricsDefault];
    [navBar setValue:@(0) forKeyPath:@"backgroundView.alpha"];
    
    
    
    
    
    YTProfileTopView *topView = [YTProfileTopView profileTopView];
    topView.frame = CGRectMake(0, -44, self.view.frame.size.width, 270);
    topView.delegate = self;
    [topView setIconImageWithImage:nil];
    [self.view addSubview:topView];
    
    
}

//实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//
//    self.navigationController.navigationBar.hidden = YES;
//    self.navigationController.navigationBar.tintColor = YTColor(0, 0, 0);
//    self.navigationController.navigationBar. translucent = YES ;
//    self.navigationController.navigationBar. alpha = 0.300;
//    
//}
- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果进入的是当前视图控制器
    if (viewController == self) {
        // 背景设置为黑色
        self.navigationController.navigationBar. tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
        // 透明度设置为0.3
        self.navigationController.navigationBar. alpha = 0.300;
        // 设置为半透明
        self.navigationController.navigationBar. translucent = YES ;
    } else {
        // 进入其他视图控制器
        self.navigationController.navigationBar.alpha = 1;
        // 背景颜色设置为系统 默认颜色
        self.navigationController.navigationBar.tintColor = nil;
        self.navigationController.navigationBar.translucent = NO; 
    } 
}



@end
