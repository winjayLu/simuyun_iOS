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

/**
 *  banner图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
/**
 *  底部图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;

/** 旧的启动图片地址 */
@property (nonatomic,copy) NSString *oldWelcome;
@end

@implementation YTWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.bannerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bottomImageView.contentMode = UIViewContentModeScaleAspectFill;
     // 先显示上次的图片
    self.oldWelcome = [CoreArchive strForKey:@"welcomeImage"];
    if (self.oldWelcome != nil && self.oldWelcome.length != 0) {
        [self.bannerImage imageWithUrlStr:self.oldWelcome phImage:nil];
    }
    
    YTResources *resources = [YTResourcesTool resources];
    if (resources != nil) { // 预加载成功
        [self.bannerImage imageWithUrlStr:resources.appWelcomeImg phImage:nil];
    }
    
    // 注册监听数据加载情况
    [YTCenter addObserver:self selector:@selector(loadSuccess) name:YTResourcesSuccess object:nil];
    
    [self timerOn];
}


/**
 *  加载成功
 */
- (void)loadSuccess
{
    // 下载新的banner图片
    YTResources *resources = [YTResourcesTool resources];
    if (![self.oldWelcome isEqualToString:resources.appWelcomeImg]) {
        [self.bannerImage imageWithUrlStr:resources.appWelcomeImg phImage:nil];
    }
    // 保存当前图片地址下次使用
    [CoreArchive setStr:resources.appWelcomeImg key:@"welcomeImage"];
}


/**
 *  转场
 */
- (void)transitionVC
{

    UIViewController *vc = nil;
    
    // 判断是否登录过
    if ([YTAccountTool account]) {
        vc = [[YTTabBarController alloc] init];
    } else {
        vc = [[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
    }
    
    
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    // 如果获取不到直接返回
    if (keyWindow == nil) return;
    keyWindow.rootViewController = vc;
    [keyWindow.layer transitionWithAnimType:TransitionAnimTypeReveal subType:TransitionSubtypesFromRight curve:TransitionCurveEaseIn duration:0.5f];
    // 关闭定时器
    [self timerOff];
}

/*
 *  新开一个定时器
 */
-(void)timerOn{
    
    [self timerOff];
    
    if(self.timer!=nil) return;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(transitionVC) userInfo:nil repeats:YES];
    
    //记录
    self.timer = timer;
}

/*
 *  关闭定时器
 */
-(void)timerOff{
    
    //关闭定时器
    [self.timer invalidate];
    
    //清空属性
    self.timer = nil;
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
