//
//  ViewController.m
//
//
//  Created by wamaker on 15/6/10.
//  Copyright (c) 2015年 wamaker. All rights reserved.
//

#import "YTProfileViewController.h"
#import "YTHomeViewController.h"
#import "YTMenuViewController.h"
#import "YTOtherViewController.h"
#import "UIView+Extension.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIImage+Extend.h"
#import "YTTabBarController.h"


typedef enum state {
    kStateHome,
    kStateMenu
}state;

static const CGFloat viewSlideHorizonRatio = 0.642;

@interface YTProfileViewController () <YTHomeViewControllerDelegate, UINavigationControllerDelegate>
@property (assign, nonatomic) state   sta;              // 状态(Home or Menu)
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat leftDistance;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值
@property (nonatomic, weak) YTHomeViewController *homeVc;   // 首页控制器
@property (nonatomic, weak) YTMenuViewController *menuVc;   // 菜单控制器
@property (nonatomic, weak) UINavigationController *nav;    // 导航控制器
@property (nonatomic, strong) UIPanGestureRecognizer *panRecongnizer; // 侧滑手势

@end

@implementation YTProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化抽屉状态
    self.sta = kStateHome;
    self.distance = 0;
    self.menuCenterXStart = 241 * 0.5;
    self.menuCenterXEnd = self.view.center.x;
    self.leftDistance = DeviceWidth * viewSlideHorizonRatio;
    
    // 设置menu的view
    YTMenuViewController *menuVc = [[YTMenuViewController alloc] init];
    menuVc.view.frame = self.view.frame;
    menuVc.view.center = CGPointMake(0, menuVc.view.center.y);
    [self addChildViewController:menuVc];
    [self.view addSubview:menuVc.view];
    self.menuVc = menuVc;
    

    // 设置首页控制器,添加手势操作
    YTHomeViewController *homeVc = [[YTHomeViewController alloc] init];
    homeVc.view.frame = [[UIScreen mainScreen] bounds];
    homeVc.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVc];
    [self addChildViewController:nav];
    self.nav = nav;
    [self addChildViewController:nav];
    [self.view addSubview:self.nav.view];
    self.nav.delegate = self;
    self.nav.interactivePopGestureRecognizer.enabled = NO;
    
    // 初始化手势
    self.panRecongnizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
}


/**
 *  处理拖动事件
 *
 *  @param recognizer
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {

    CGFloat x = [recognizer translationInView:self.view].x;
    // 禁止在主界面的时候向左滑动
    if ( x < 0) {
        [self showHome];
        return;
    }
    // 最大滑动范围241
    if (x > 240) {
        [self showMenu];
        return;
    }
    
    CGFloat dis = self.distance + x;
    
    if (recognizer.state == UIGestureRecognizerStateCancelled) {
        [self showHome];
        return;
    }
    
    // 当手势停止时执行操作
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (dis >= 241 * 0.5) {
            [self showMenu];
        } else {
            [self showHome];
        }
        return;
    }
    self.nav.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y);
    CGFloat menuCenterMove = dis * (self.menuCenterXEnd - self.menuCenterXStart) / self.leftDistance;
    self.menuVc.view.center = CGPointMake(self.menuCenterXStart + menuCenterMove, self.view.center.y);
}

/**
 *  展示侧边栏
 */
- (void)showMenu {
    self.distance = self.leftDistance;
    self.sta = kStateMenu;
    [self doSlide:0];
}

/**
 *  展示主界面
 */
- (void)showHome {
    self.distance = 0;
    self.sta = kStateHome;
    [self doSlide:1];
}

/**
 *  实施自动滑动
 *
 *  @param proportion 滑动比例
 */
- (void)doSlide:(CGFloat)proportion {
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat menuCenterX;
        CGFloat navCenterX;
        if (proportion == 1) {
            menuCenterX = 0;
            navCenterX = DeviceWidth * 0.5;
            self.nav.view.center = self.view.center;
            self.menuVc.view.center = CGPointMake(menuCenterX, self.view.center.y);
        } else {
            menuCenterX = DeviceWidth * 0.5;
            navCenterX = menuCenterX + 241;
            self.nav.view.center = CGPointMake(navCenterX, DeviceHight * 0.5);
            self.menuVc.view.center = CGPointMake(menuCenterX, self.view.center.y);
        }
    } completion:^(BOOL finished) {
        if (proportion != 1) {
            // 设置遮盖
            UIButton *cover = [[UIButton alloc] init];
            cover.frame = self.nav.view.frame;
            cover.backgroundColor = [UIColor clearColor];
            [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchDown];
            [self.view addSubview:cover];
        }
    }];
}
/**
 *  遮盖点击事件
 */
- (void)coverClick:(UIButton *)cover
{
    [cover removeFromSuperview];
    [self showHome];
}

- (void)leftMenuClicked
{
    [self coverClick:nil];
}

#pragma mark - HomeViewController代理方法
- (void)leftBtnClicked {
    [self showMenu];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
//
- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 获取根控制器
    YTTabBarController *appRootVC = (YTTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    // 如果进入的是首页视图控制器
    if ([viewController isKindOfClass:[YTHomeViewController class]]) {

        // 设置为半透明
        [self.nav.navigationBar lt_setBackgroundColor:[YTColor(255, 255, 255) colorWithAlphaComponent:0.0]];
        // 添加手势
        [self.nav.view addGestureRecognizer:self.panRecongnizer];
        // 显示tabbar
        appRootVC.tabBar.hidden =  NO;
    } else {
        // 进入其他视图控制器
        [self.nav.navigationBar lt_setBackgroundColor:[YTNavBackground colorWithAlphaComponent:1.0]];
        // 删除手势
        [self.nav.view removeGestureRecognizer:self.panRecongnizer];
        // 隐藏tabbar
        appRootVC.tabBar.hidden = YES;
    }
}




@end

