//
//  YTMessageViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTMessageViewController.h"
//#import "UMSocial.h"
//#import "ShareCustomView.h"
#import "TempViewController.h"


@interface YTMessageViewController () 

@end

@implementation YTMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YTRandomColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(100, 100);
    [self.view addSubview:button];
    
    
}

- (void)buttonClick
{
    [self presentViewController:[[TempViewController alloc]init]  animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
