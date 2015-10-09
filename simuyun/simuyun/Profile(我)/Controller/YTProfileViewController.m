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

static const CGFloat viewSlideHorizonRatio = 0.5;
static const CGFloat viewHeightNarrowRatio = 0.80;
static const CGFloat menuStartNarrowRatio  = 0.70;

@interface YTProfileViewController () <YTHomeViewControllerDelegate, YTMenuViewControllerDelegate>
@property (assign, nonatomic) state   sta;              // 状态(Home or Menu)
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat leftDistance;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值

@property (nonatomic, weak) YTHomeViewController *homeVc;   // 首页控制器
@property (nonatomic, weak) YTMenuViewController *menuVc;   // 菜单控制器
@property (strong, nonatomic) UIView *cover;    // 左侧遮盖
@property (nonatomic, weak) UINavigationController *nav;    // 导航控制器

@end

@implementation YTProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化抽屉状态
    self.sta = kStateHome;
    self.distance = 0;
    self.menuCenterXStart = DeviceWidth * menuStartNarrowRatio / 2.0;
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
    menuVc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuStartNarrowRatio, menuStartNarrowRatio);
    menuVc.view.center = CGPointMake(self.menuCenterXStart, menuVc.view.center.y);
    [self addChildViewController:menuVc];
    [self.view addSubview:menuVc.view];
    self.menuVc = menuVc;
    
    // 设置遮盖
    self.cover = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.cover.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.cover];
    
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
    
    CGFloat proportion = (viewHeightNarrowRatio - 1) * dis / self.leftDistance + 1;
    if (proportion < viewHeightNarrowRatio || proportion > 1) {
        return;
    }
    self.nav.view.center = CGPointMake(self.view.center.x + dis, self.view.center.y);

    
//    self.homeVc.leftBtn.alpha = self.cover.alpha = 1 - dis / self.leftDistance;
    
    CGFloat menuProportion = dis * (1 - menuStartNarrowRatio) / self.leftDistance + menuStartNarrowRatio;
    CGFloat menuCenterMove = dis * (self.menuCenterXEnd - self.menuCenterXStart) / self.leftDistance;
    self.menuVc.view.center = CGPointMake(self.menuCenterXStart + menuCenterMove, self.view.center.y);
    self.menuVc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
}

/**
 *  展示侧边栏
 */
- (void)showMenu {
    self.distance = self.leftDistance;
    self.sta = kStateMenu;
    [self doSlide:viewHeightNarrowRatio];
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
        self.nav.view.center = CGPointMake(self.view.center.x + self.distance, self.view.center.y);
        
        
        
//        self.homeVc.leftBtn.alpha = self.cover.alpha = proportion == 1 ? 1 : 0;
        
        CGFloat menuCenterX;
        CGFloat menuProportion;
        if (proportion == 1) {
            menuCenterX = self.menuCenterXStart;
            menuProportion = menuStartNarrowRatio;

        } else {
            menuCenterX = self.menuCenterXEnd;
            menuProportion = 1;
            
        }
        self.menuVc.view.center = CGPointMake(menuCenterX, self.view.center.y);
        self.menuVc.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, menuProportion, menuProportion);
    } completion:nil];
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


@end

