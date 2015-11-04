//
//  YTReportContentController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTReportContentController.h"
#import "YTReportViewController.h"

@interface YTReportContentController ()

@end

@implementation YTReportContentController

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
    self.title = @"订单报备";
    YTReportViewController *report = [[YTReportViewController alloc] init];
    report.view.frame = CGRectMake(0, 0, DeviceWidth, 1000);
    report.scroll = (UIScrollView *)self.view;
    report.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:report];
    [self.view addSubview:report.view];
    report.prouctModel = self.prouctModel;
    
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, 667)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
