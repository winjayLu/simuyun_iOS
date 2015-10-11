  //
//  YTTabBarController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  主控制器

#import "YTTabBarController.h"
#import "YTMessageViewController.h"
#import "YTProductViewController.h"
#import "YTProfileViewController.h"
#import "YTSchoolViewController.h"
#import "YTDiscoverViewController.h"
#import "YTNavigationController.h"
#import "YTLogoView.h"


@interface YTTabBarController () <YTLogoViewDelegate>
/**
 *  消息 控制器
 */
@property (nonatomic, strong) YTMessageViewController *message;
/**
 *  产品 控制器
 */
@property (nonatomic, strong) YTProductViewController *product;
/**
 *  我 控制器
 */
@property (nonatomic, strong) YTProfileViewController *profile;
/**
 *  学院 控制器
 */
@property (nonatomic, strong) YTSchoolViewController *school;
/**
 *  发现 控制器
 */
@property (nonatomic, strong) YTDiscoverViewController *discover;

/**
 *  tabBar中间的logo按钮
 */
@property (nonatomic, weak) YTLogoView *logo;

@end



@implementation YTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildVc];

    // 设置tabBar的样式
    [self setupTabBarStyle];
    
    // 选中个人中心控制器
    [self logoViewDidSelectProfileItem];
    
}

/**
 *  初始化子控制器
 */
- (void)setupChildVc
{
    self.message = (YTMessageViewController *)[self addOneChildVcClass:[YTMessageViewController class] title:@"消息" image:@"" selectedImage:@""];
    self.product = (YTProductViewController *)[self addOneChildVcClass:[YTProductViewController class] title:@"产品" image:@"" selectedImage:@""];
    self.profile = (YTProfileViewController *)[self addOneChildVcClass:[YTProfileViewController class] title:nil image:nil selectedImage:nil];
    self.discover = (YTDiscoverViewController *)[self addOneChildVcClass:[YTDiscoverViewController class] title:@"发现" image:@"" selectedImage:@""];
    self.school = (YTSchoolViewController *)[self addOneChildVcClass:[YTSchoolViewController class] title:@"学院" image:@"" selectedImage:@""];
}

/**
 *  初始化tabBar的样式
 */
- (void)setupTabBarStyle
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
#warning 设置tabBar的背景颜色,或图片
    self.tabBar.backgroundColor = [UIColor blackColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/**
 *  视图即将显示的时候调用
 *
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 添加一个logo按钮到tabBar上
    [self setupLogoView];
}

- (void)setupLogoView
{
    YTLogoView *logo = [[YTLogoView alloc] init];
    logo.backgroundColor = [UIColor redColor];
    logo.size = CGSizeMake(100, 100);
    logo.center = CGPointMake(self.tabBar.width * 0.5, self.tabBar.height * 0.5);
    logo.userInteractionEnabled = YES;
    logo.delegate = self;
    [self.tabBar addSubview:logo];
    self.logo = logo;
    
}

- (void)logoViewDidSelectProfileItem
{
    [self setSelectedIndex:2];
}


/**
 * 添加一个子控制器
 * @param vcClass : 子控制器的类名
 * @param title : 标题
 * @param image : 图片
 * @param selectedImage : 选中的图片
 */
- (UIViewController *)addOneChildVcClass:(Class)vcClass title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIViewController *vc = [[vcClass alloc] init];

    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor yellowColor]
                                            } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor whiteColor]
                                            } forState:UIControlStateNormal];
    
    // 同时设置tabbar每个标签的文字和图片
    if (![vc isKindOfClass:[YTProfileViewController class]]) {  // 忽略个人中心界面
        vc.title = title;
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
        // 包装一个导航控制器后,再成为tabbar的子控制器
        
        YTNavigationController *nav = [[YTNavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
    } else {
        [self addChildViewController:vc];
    }
    
    return vc;
}


@end



