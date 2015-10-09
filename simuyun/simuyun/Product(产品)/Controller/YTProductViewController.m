//
//  YTProductViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTProductViewController.h"
#import "YTWebViewController.h"

@interface YTProductViewController ()

@end

@implementation YTProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YTRandomColor;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(200, 200, 200, 200);
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)btnClick
{
    YTWebViewController *web = [[YTWebViewController alloc] init];
    web.url = @"http://www.baidu.com";
    [self.navigationController pushViewController:web animated:YES];
}


@end
