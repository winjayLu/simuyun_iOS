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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    YTLeftMenu *leftMenu = [YTLeftMenu leftMenu];
    leftMenu.frame = CGRectMake(0, 0, 241, DeviceHight);
    [self.view addSubview:leftMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
