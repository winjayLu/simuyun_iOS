//
//  YTReportContentController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTReportContentController.h"
#import "YTReportViewController.h"
#import "YTReportTopView.h"

@interface YTReportContentController ()

/**
 *  顶部视图
 */
@property (nonatomic, weak) UIView *topView;

/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *mainView;
@end

@implementation YTReportContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单报备";
    self.view.backgroundColor = [UIColor whiteColor];
    // 初始化顶部视图
    [self setupTopView];
    
    // 初始化滚动视图
    [self setupScrollView];
    
    // 初始化子视图
    [self setupSubView];
}

/**
 * 初始化顶部视图
 */
- (void)setupTopView
{
    YTReportTopView *topView = [YTReportTopView reportTopView];
    topView.prouctModel = self.prouctModel;
    [self.view addSubview:topView];
    self.topView = topView;
}

/**
 *  初始化滚动视图
 */
- (void)setupScrollView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), DeviceWidth, DeviceHight)];
    mainView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainView];
    self.mainView = mainView;
}

/**
 *  初始化子视图
 */
- (void)setupSubView
{
    YTReportViewController *report = [[YTReportViewController alloc] init];
    report.view.frame = CGRectMake(0, 0, DeviceWidth, report.view.height + 180);
    report.scroll = self.mainView;
    report.view.backgroundColor = [UIColor whiteColor];
    report.prouctModel = self.prouctModel;
    [self addChildViewController:report];
    [self.mainView addSubview:report.view];
    
    [self.mainView setContentSize:CGSizeMake(DeviceWidth, report.view.height)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
