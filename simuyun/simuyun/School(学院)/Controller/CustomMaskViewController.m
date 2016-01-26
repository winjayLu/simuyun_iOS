//
//  CustomMaskViewController.m
//  TCCloudPlayerSDKTest
//
//  Created by AlexiChen on 15/8/19.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "CustomMaskViewController.h"
#import "TCCloudPlayerVideoUrlInfo.h"
#import "YTSchoolViewController.h"
#import "YTTabBarController.h"


@interface CustomMaskViewController ()

/**
 *  内容容器
 */
@property (nonatomic, strong) UIView *ContentView;


@end

@implementation CustomMaskViewController

- (CGRect)playViewFrame
{
    return CGRectMake(0 , 20, DeviceWidth, DeviceWidth * 0.5625);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self playVideo];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor blackColor]];
    button.frame = CGRectMake(40, 150, 40, 40);
    [self.ContentView addSubview:button];
    
    UIButton *button2 = [[UIButton alloc] init];
    [button2 setTitle:@"隐藏" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(hiddenClick) forControlEvents:UIControlEventTouchUpInside];
    [button2 setBackgroundColor:[UIColor blackColor]];
    button2.frame = CGRectMake(DeviceWidth - 80, 150, 40, 40);
    [self.ContentView addSubview:button2];
}

- (void)closeClick
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
        tabBar.playerVc = nil;
    }
}
- (void)hiddenClick
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // 获取根控制器
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    // 如果获取不到直接返回
    if (keyWindow == nil) return;
    
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        ((YTTabBarController *)appRootVC).playerVc = self;
        ((YTTabBarController *)appRootVC).floatView = [FloatView defaultFloatViewWithButton];
    }
    //初始化
    
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}


- (void)playVideo
{
    NSMutableArray* mutlArray = [NSMutableArray array];
    TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info.videoUrlTypeName = @"原始";
    info.videoUrl = [NSURL URLWithString:@"http://2527.vod.myqcloud.com/2527_117134a2343111e5b8f5bdca6cb9f38c.f20.mp4"];
    [mutlArray addObject:info];
    
    TCCloudPlayerVideoUrlInfo* info1 = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info1.videoUrlTypeName = @"标清";
    info1.videoUrl = [NSURL URLWithString:@"http://2527.vod.myqcloud.com/2527_117134a2343111e5b8f5bdca6cb9f38c.f30.mp4"];
    [mutlArray addObject:info1];
    
    [self loadVideoPlaybackView:mutlArray defaultPlayIndex:0 startTime:0];
}

- (void)changeContentView:(BOOL)isShow
{
    self.ContentView.hidden = isShow;
}

- (UIView *)ContentView
{
    if (!_ContentView) {
        // 获取视频播放器最大宽度
        CGFloat playerMaxY = CGRectGetMaxY(_playerView.frame);
        _ContentView = [[UIView alloc] initWithFrame:CGRectMake(0, playerMaxY, DeviceWidth, DeviceHight - playerMaxY)];
        [self.view addSubview:_ContentView];
    }
    return _ContentView;
}





@end
