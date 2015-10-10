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


typedef enum state {
    kStateHome,
    kStateMenu
}state;

static const CGFloat viewSlideHorizonRatio = 0.642;
//static const CGFloat viewHeightNarrowRatio = 0.6;

@interface YTProfileViewController () <YTHomeViewControllerDelegate, YTMenuViewControllerDelegate>
@property (assign, nonatomic) state   sta;              // 状态(Home or Menu)
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat leftDistance;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值
@property (nonatomic, weak) YTHomeViewController *homeVc;   // 首页控制器
@property (nonatomic, weak) YTMenuViewController *menuVc;   // 菜单控制器
@property (nonatomic, weak) UINavigationController *nav;    // 导航控制器

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
    
    // 设置背景
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    bg.frame = [[UIScreen mainScreen] bounds];
    [self.view addSubview:bg];
    
    
    // 设置menu的view
    YTMenuViewController *menuVc = [[YTMenuViewController alloc] init];
    menuVc.delegate = self;
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
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.nav.view addGestureRecognizer:pan];
    [self.view addSubview:self.nav.view];
    

}


/**
 *  处理拖动事件
 *
 *  @param recognizer
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // 当滑动水平X大于75时禁止滑动
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartX = [recognizer locationInView:self.view].x;
    }
    if (self.sta == kStateHome && self.panStartX >= 200) {
        return;
    }
    
    CGFloat x = [recognizer translationInView:self.view].x;
    // 禁止在主界面的时候向左滑动
    if (self.sta == kStateHome && x < 0) {
        return;
    }
    
    CGFloat dis = self.distance + x;
    // 当手势停止时执行操作
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (dis >= DeviceWidth * viewSlideHorizonRatio / 2.0) {
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
    [self doSlide:viewSlideHorizonRatio];
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
        } else {
            menuCenterX = DeviceWidth * 0.5;
            navCenterX = menuCenterX + 241;
        }
        self.nav.view.center = CGPointMake(navCenterX, DeviceHight * 0.5);
        self.menuVc.view.center = CGPointMake(menuCenterX, self.view.center.y);
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

#pragma mark - WMHomeViewController代理方法
- (void)leftBtnClicked {
    [self showMenu];
}

#pragma mark - WMMenuViewController代理方法
- (void)didSelectItem:(NSString *)title {
//    WMOtherViewController *other = [[WMOtherViewController alloc] init];
//    other.navTitle = title;
//    other.hidesBottomBarWhenPushed = YES;
    //    [self.messageNav pushViewController:other animated:NO];
    [self showHome];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end

