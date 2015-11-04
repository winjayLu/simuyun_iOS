//
//  YTOrderdetailController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTOrderdetailController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "YTReportContentController.h"
#import "YTProductModel.h"
#import "YTNormalWebController.h"

@interface YTOrderdetailController () <UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;

/**
 *  进度条代理
 */
@property (nonatomic, strong) YHWebViewProgress *progressProxy;
@end

@implementation YTOrderdetailController

- (void)loadView
{
    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    
    // 获取当前时间
    //    [[NSDate date] stringWithFormater:@""];
    [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    mainView.scalesPageToFit = YES;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    mainView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, -49, 0);
    mainView.delegate = self;
    self.view = mainView;
    self.webView = mainView;
    self.view.backgroundColor = YTGrayBackground;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    
    
    // 初始化进度条
    [self setupProgress];
    
    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

/**
 *  初始化进度条
 */
- (void)setupProgress
{
    // 创建进度条
    YHWebViewProgressView *progressView = [[YHWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 2)];
    progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    progressView.barAnimationDuration = 0.5;
    progressView.progressBarColor = YTViewBackground;
    // 设置进度条
    self.progressProxy.progressView = progressView;

    // 添加到视图
    [self.view addSubview:progressView];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSArray *result = [urlString componentsSeparatedByString:@":"];
    NSMutableArray *urlComps = [[NSMutableArray alloc] init];
    for (NSString *str in result) {
        [urlComps addObject:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"app"])
    {
        // 跳转的地址和标题
        if (urlComps.count) {
            NSString *command = urlComps[1];
            if ([command isEqualToString:@"closepage"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            } else if ([command isEqualToString:@"filing"]) // 报备
            {
                YTReportContentController *report = [[YTReportContentController alloc] init];
                YTProductModel *product = [[YTProductModel alloc] init];
                product.order_code = self.order.order_code;
                product.customerName = self.order.cust_name;
                product.buyMoney = self.order.order_amt;
                product.order_id = self.order.order_id;
                report.prouctModel = product;
                [self.navigationController pushViewController:report animated:YES];
            } else if ([command isEqualToString:@"openpage"])
            {
                YTNormalWebController *normal = [[YTNormalWebController alloc] init];
                normal.url = [NSString stringWithFormat:@"%@%@", YTH5Server, urlComps[2]];
                normal.isDate = YES;
                normal.toTitle = urlComps[3];
                [self.navigationController pushViewController:normal animated:YES];
            }
        }
    }
    return YES;
}





#pragma mark - lazy
- (YHWebViewProgress *)progressProxy
{
    if (!_progressProxy) {
        _progressProxy = [[YHWebViewProgress alloc] init];
    }
    return _progressProxy;
}

/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
