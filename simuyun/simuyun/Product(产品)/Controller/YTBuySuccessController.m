//
//  YTBuySuccessController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/20.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBuySuccessController.h"
#import "YTReportContentController.h"

@interface YTBuySuccessController ()

/**
 *  报备
 */

- (IBAction)reportClick:(UIButton *)sender;

@end

@implementation YTBuySuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    UIScrollView *mainView = (UIScrollView *)self.view;
// 
//    mainView.bounces = NO;
//    mainView.showsVerticalScrollIndicator = NO;
//    self.view.backgroundColor = YTViewBackground;
    // 设置滚动范围
//    mainView.contentSize = CGSizeMake(0, 1200);
//    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, 600)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)reportClick:(UIButton *)sender {
    YTReportContentController *report = [[YTReportContentController alloc] init];
    [self.navigationController pushViewController:report animated:YES];
    
}
@end
