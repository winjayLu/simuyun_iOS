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
#import "UIView+Extension.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIImage+Extend.h"
#import "YTTabBarController.h"


typedef enum state {
    kStateHome,
    kStateMenu
}state;

static const CGFloat viewSlideHorizonRatio = 0.642;

@interface YTProfileViewController () <YTHomeViewControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@property (assign, nonatomic) state   sta;              // 状态(Home or Menu)
@property (assign, nonatomic) CGFloat distance;         // 距离左边的边距
@property (assign, nonatomic) CGFloat leftDistance;
@property (assign, nonatomic) CGFloat menuCenterXStart; // menu起始中点的X
@property (assign, nonatomic) CGFloat menuCenterXEnd;   // menu缩放结束中点的X
@property (assign, nonatomic) CGFloat panStartX;        // 拖动开始的x值
@property (nonatomic, weak) YTHomeViewController *homeVc;   // 首页控制器
@property (nonatomic, weak) YTMenuViewController *menuVc;   // 菜单控制器
@property (nonatomic, strong) UIPanGestureRecognizer *panRecongnizer; // 侧滑手势

// 是否可以滑动
@property (nonatomic, assign) BOOL isPan;


@end

@implementation YTProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    // 初始化抽屉状态
    self.sta = kStateHome;
    self.distance = 0;
    self.menuCenterXStart = 241 * 0.5;
    self.menuCenterXEnd = self.view.center.x;
    self.leftDistance = DeviceWidth * viewSlideHorizonRatio;
    

    // 设置首页控制器,添加手势操作
    YTHomeViewController *homeVc = [[YTHomeViewController alloc] init];
    homeVc.view.frame = [[UIScreen mainScreen] bounds];
    homeVc.delegate = self;
    self.homeVc = homeVc;

    
    // 设置menu的view
    YTMenuViewController *menuVc = [[YTMenuViewController alloc] init];
    menuVc.view.frame = self.view.frame;
    [self addChildViewController:menuVc];
    [self.view addSubview:menuVc.view];
    self.menuVc = menuVc;
    
    [self addChildViewController:homeVc];
    [self.view addSubview:homeVc.view];
    
    // 初始化手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = self;
    [self.homeVc.view addGestureRecognizer:pan];
    self.panRecongnizer = pan;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    return YES;
}


/**
 *  处理拖动事件
 *
 *  @param recognizer
 */
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    
    // 手指当前位置
    CGFloat locationX = [recognizer locationInView:self.view].x;
    
    // 移动
    CGFloat x = [recognizer translationInView:self.view].x;
//    YTLog(@"手指当前位置%f", locationX);
//    YTLog(@"移动范围%f", x);
    if (locationX > 60 && self.isPan == NO) {
        [self showHome];
        return;
    }
    self.isPan = YES;

    // 禁止在主界面的时候向左滑动
    if ( x < 0) {
        [self showHome];
        return;
    }
    // 最大滑动范围241
    if (x > 0) {
        [self showMenu];
        return;
    }
}


/**
 *  展示侧边栏
 */
- (void)showMenu {

    self.distance = self.leftDistance;
    self.sta = kStateMenu;
    [self doSlide:0];
    [self.homeVc.view removeGestureRecognizer:self.panRecongnizer];
}

/**
 *  展示主界面
 */
- (void)showHome {
    self.distance = 0;
    self.sta = kStateHome;
    [self doSlide:1];
    [self.homeVc.view addGestureRecognizer:self.panRecongnizer];
}

/**
 *  实施自动滑动
 *
 *  @param proportion 滑动比例
 */
static UIWindow *_window;
- (void)doSlide:(CGFloat)proportion {
    
    __block CGFloat menuCenterX;
    __block CGFloat navCenterX;
    
    [UIView animateWithDuration:0.3 animations:^{
        YTTabBarController *appRootVC = (YTTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        CGPoint old = appRootVC.tabBar.center;
        if (proportion == 1) {
            menuCenterX = 0;
            navCenterX = DeviceWidth * 0.5;
            self.homeVc.view.center = self.view.center;
            self.menuVc.view.center = CGPointMake(menuCenterX, self.view.center.y);
            appRootVC.tabBar.center = CGPointMake(self.homeVc.view.center.x, old.y);
        } else {
            menuCenterX = DeviceWidth * 0.5;
            navCenterX = menuCenterX + 241;
            self.homeVc.view.center = CGPointMake(navCenterX, DeviceHight * 0.5);
            self.menuVc.view.center = CGPointMake(menuCenterX, self.view.center.y);
            appRootVC.tabBar.center = CGPointMake(self.homeVc.view.center.x, old.y);
            
        }
    } completion:^(BOOL finished) {
        if (proportion != 1) {
            // 设置遮盖
            
            _window = [[UIWindow alloc]initWithFrame:CGRectMake(self.homeVc.view.x, 20, self.homeVc.view.width, self.homeVc.view.height)];
            _window.backgroundColor = [UIColor clearColor];
            _window.windowLevel = UIWindowLevelNormal;
            _window.hidden = NO;

            [_window makeKeyAndVisible];

            // 设置按钮
            UIButton *cover = [[UIButton alloc] init];
            cover.frame = _window.bounds;
            cover.backgroundColor = [UIColor clearColor];
            [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchDown];
            [_window addSubview:cover];
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/**
 *  遮盖点击事件
 */
- (void)coverClick:(UIButton *)cover
{
    [_window.subviews[0] removeFromSuperview];
//    [cover removeFromSuperview];
    _window.hidden = YES;
    [_window removeFromSuperview];
    _window = nil;
    self.isPan = NO;
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


- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    // 如果进入的是首页视图控制器
    if ([viewController isKindOfClass:[YTProfileViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];

    } else {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    // 如果进入的是首页视图控制器
//    if ([viewController isKindOfClass:[YTHomeViewController class]]) {
//        
//        // 添加手势
//        [self.navigationController.view addGestureRecognizer:self.panRecongnizer];
//
//    } else {
//        // 删除手势
//        [self.navigationController.view removeGestureRecognizer:self.panRecongnizer];
//    }
//
//}





@end

