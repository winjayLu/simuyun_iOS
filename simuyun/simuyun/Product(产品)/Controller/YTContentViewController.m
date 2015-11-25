//
//  YTContentViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/20.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTContentViewController.h"
#import "YTBuySuccessController.h"
#import "UIBarButtonItem+Extension.h"

@interface YTContentViewController ()

/**
 *  banner视图
 */
@property (nonatomic, weak) UIImageView *banner;
/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *mainView;
@end

@implementation YTContentViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YTGrayBackground;
    
    // 初始化banner视图
    [self setupBanner];
    
    // 初始化滚动视图
    [self setupScrollView];

    // 初始化子视图
    [self setupSubView];
}

/**
 *  初始化banner视图
 */
- (void)setupBanner
{
    UIImageView *banner = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 120)];
    banner.image = [UIImage imageNamed:@"edqzcgbannner"];
    [self.view addSubview:banner];
    self.banner = banner;
}

/**
 *  初始化滚动视图
 */
- (void)setupScrollView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.banner.frame), DeviceWidth, DeviceHight)];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    self.mainView = mainView;
    self.title = @"认购成功";
}

/**
 *  初始化子视图
 */
- (void)setupSubView
{
    YTBuySuccessController *success = [[YTBuySuccessController alloc] init];
    success.view.frame = CGRectMake(0, 0, DeviceWidth, success.view.size.height);
    [self addChildViewController:success];
    [self.mainView addSubview:success.view];
    success.prouctModel = self.prouctModel;
    [self.mainView setContentSize:CGSizeMake(success.view.width, success.view.size.height + 200)];
    // 初始化左侧返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"fanhui" target:self action:@selector(blackClick)];
}


- (void)blackClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
