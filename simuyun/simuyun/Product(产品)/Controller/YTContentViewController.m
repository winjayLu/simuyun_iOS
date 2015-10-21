//
//  YTContentViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/20.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTContentViewController.h"
#import "YTBuySuccessController.h"

@interface YTContentViewController ()

@end

@implementation YTContentViewController

- (void)loadView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
    mainView.showsVerticalScrollIndicator = NO;
    self.view = mainView;
    self.view.backgroundColor = YTGrayBackground;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    YTBuySuccessController *success = [[YTBuySuccessController alloc] init];
    success.view.frame = CGRectMake(0, 0, DeviceWidth, success.view.size.height);
    [self addChildViewController:success];
    [self.view addSubview:success.view];
    [(UIScrollView *)self.view setContentSize:success.view.size];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
