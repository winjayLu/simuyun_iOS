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
    
    YTReportViewController *report = [[YTReportViewController alloc] init];
    report.view.frame = CGRectMake(0, 0, DeviceWidth, report.view.height);
    report.scroll = (UIScrollView *)self.view;
    [self addChildViewController:report];
    [self.view addSubview:report.view];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, report.view.height - 64)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
