//
//  YTOtherViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import "YTOtherViewController.h"

@interface YTOtherViewController ()

- (IBAction)btnClick:(UIButton *)sender;
@end

@implementation YTOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnClick:(UIButton *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
