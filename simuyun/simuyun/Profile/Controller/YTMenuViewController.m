//
//  YTMenuViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import "YTMenuViewController.h"
#import "YTLeftMenu.h"
#import "YTUserInfoTool.h"

@interface YTMenuViewController ()

@property (nonatomic, weak) YTLeftMenu *leftMenu;

@end

@implementation YTMenuViewController


- (void)loadView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
    mainView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化左侧菜单
    YTLeftMenu *leftMenu = [YTLeftMenu leftMenu];
    leftMenu.frame = CGRectMake(0, 0, 241, 667);
    // 6P 特殊处理
    if (DeviceHight > 667) {
        leftMenu.height = DeviceHight;
    }
   
    [self.view addSubview:leftMenu];
    self.leftMenu = leftMenu;
    
    // 设置ScrollView的滚动范围
    [(UIScrollView *)self.view setContentSize:CGSizeMake(leftMenu.width, leftMenu.height - 69)];
    self.leftMenu.userInfo = [YTUserInfoTool userInfo];
    // 监听通知
    [YTCenter addObserver:self selector:@selector(leftUpdate) name:YTUpdateIconImage object:nil];
    [YTCenter addObserver:self selector:@selector(logOut) name:YTLogOut object:nil];
    
}


/**
 *  更新数据
 */
- (void)leftUpdate
{
    self.leftMenu.userInfo = [YTUserInfoTool userInfo];
}

- (void)logOut
{
    [self.leftMenu logOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [YTCenter removeObserver:self];
}


@end
