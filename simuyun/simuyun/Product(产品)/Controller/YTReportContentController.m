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
#import "YTCusomerModel.h"
#import "QKInfoCard.h"
#import "YTCustomerView.h"
#import "AFNetworking.h"
#import "NSString+Extend.h"
#import "YTAccountTool.h"
#import "YTUserInfoTool.h"

@interface YTReportContentController ()

/**
 *  顶部视图
 */
@property (nonatomic, weak) UIView *topView;

/**
 *  滚动视图
 */
@property (nonatomic, weak) UIScrollView *mainView;

// 选择客户
@property (nonatomic, weak) QKInfoCard *infoCard;

/**
 *  客户列表
 */
@property (nonatomic, strong) NSMutableArray *customers;

/**
 *  报备控制器
 */
@property (nonatomic, weak) YTReportViewController *reportVc;
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
    // 获取客户信息
    [self loadCustomer];
    
    [YTCenter addObserver:self selector:@selector(selectCustomer) name:YTSelectedCustomer object:nil];
    // 取消选择
    [YTCenter addObserver:self selector:@selector(cancelCustomer) name:YTCancelCustomer object:nil];
}

/**
 *  选中了客户
 */
- (void)selectCustomer
{
    // 获取选中的客户
    YTCusomerModel *customer = [self.infoCard selectCusomer];
    self.reportVc.cusomerModel = customer;
    [self.infoCard hide];
    self.infoCard = nil;
    [MobClick event:@"orderDetail_click" attributes:@{ @"按钮" : @"快速报备确认", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}

- (void)cancelCustomer
{
    [self.infoCard hide];
    [MobClick event:@"orderDetail_click" attributes:@{ @"按钮" : @"快速报备取消", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}

/**
 *  获取客户列表
 */
- (void)loadCustomer
{
    
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个GET请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTCust];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cust_name"] = self.prouctModel.customerName;
    params[@"adviser_id"] = [YTAccountTool account].userId;
    [mgr GET:newUrl parameters:[NSDictionary httpWithDictionary:params]
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         self.customers = [YTCusomerModel objectArrayWithKeyValuesArray:responseObject];
         // 如果客户数量>0
         if (self.customers.count > 0)
         {
             QKInfoCard *infoCard = [[QKInfoCard alloc] initWithView:self.view];
             NSMutableArray *array = [[NSMutableArray alloc] init];
             for (YTCusomerModel *cusomer in self.customers) {
                 YTCustomerView *view = [YTCustomerView customerView];
                 view.cusomer = cusomer;
                 [array addObject:view];
             }
             infoCard.containerSubviews = array;
             [self.view addSubview:infoCard];
             self.infoCard = infoCard;
             [infoCard show];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
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
    report.prouctModel = self.prouctModel;
    report.view.frame = CGRectMake(0, 0, DeviceWidth, report.view.height + 180);
    report.scroll = self.mainView;
    report.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:report];
    self.reportVc = report;
    [self.mainView addSubview:report.view];
    
    [self.mainView setContentSize:CGSizeMake(DeviceWidth, report.view.height)];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)customers
{
    if (!_customers) {
        _customers = [[NSMutableArray alloc] init];
    }
    return _customers;
}

- (void)dealloc
{
    [YTCenter removeObserver:self];
}

@end
