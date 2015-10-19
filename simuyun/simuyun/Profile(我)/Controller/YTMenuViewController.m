//
//  YTMenuViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import "YTMenuViewController.h"
#import "YTLeftMenu.h"

@interface YTMenuViewController ()

@end

@implementation YTMenuViewController


- (void)loadView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    self.view = mainView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    // 初始化左侧菜单
    YTLeftMenu *leftMenu = [YTLeftMenu leftMenu];
    leftMenu.frame = CGRectMake(0, 0, 241, DeviceHight);
    [self.view addSubview:leftMenu];
    
    // 设置ScrollView的滚动范围
    [(UIScrollView *)self.view setContentSize:CGSizeMake(leftMenu.width, leftMenu.height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
