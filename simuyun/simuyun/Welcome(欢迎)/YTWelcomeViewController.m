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
#import "YTResourcesTool.h"
#import "UIImageView+SD.h"
#import "CoreArchive.h"


@interface YTWelcomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@end

@implementation YTWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YTResources *resources = [YTResourcesTool resources];
    if (resources != nil) { // 预加载成功
        [self.bannerImage imageWithUrlStr:resources.appWelcomeImg phImage:nil];
        [self switchViewControllerDuration:3.0];
    } else {    // 先显示上次的图片
        NSString *welcomeImage = [CoreArchive strForKey:@"welcomeImage"];
        if (welcomeImage != nil && welcomeImage.length != 0) {
            [self.bannerImage imageWithUrlStr:welcomeImage phImage:nil];
        }
    }
    
    // 注册监听数据加载情况
    [YTCenter addObserver:self selector:@selector(loadSuccess) name:YTResourcesSuccess object:nil];
    [YTCenter addObserver:self selector:@selector(loadError) name:YTResourcesError object:nil];
}

/**
 *  加载成功
 */
- (void)loadSuccess
{
    // 下载新的banner图片
    YTResources *resources = [YTResourcesTool resources];
    [self.bannerImage imageWithUrlStr:resources.appWelcomeImg phImage:nil];
    [self switchViewControllerDuration:0.25];
    
    // 保存当前图片地址下次使用
    [CoreArchive setStr:resources.appWelcomeImg key:@"welcomeImage"];
}

/**
 *  加载失败
 */
- (void)loadError
{
    [self transitionMainVC:[[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]]];
}

/**
 *  选择控制器
 */
- (void)switchViewControllerDuration:(double)duration
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([YTAccountTool account]) {
            [YTAccountTool loginAccount:[YTAccountTool account] result:^(BOOL result) {
                if (result) {
                    [self transitionMainVC:[[YTTabBarController alloc] init]];
                } else {
                    [self transitionMainVC:[[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]]];
                }
            }];
        }
    });
}

/**
 *  转场
 */
- (void)transitionMainVC:(UIViewController *)vc
{
    // 获取程序主窗口
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.rootViewController = vc;
    [mainWindow.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
}

#pragma mark - 准备数据
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)dealloc
{
    [YTCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
