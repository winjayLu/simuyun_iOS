//
//  YTOrderdetailController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTOrderdetailController.h"
#import "YTReportContentController.h"
#import "YTProductModel.h"
#import "YTNormalWebController.h"
#import "YTUserInfoTool.h"
#import "YTProductdetailController.h"
#import "YTAccountTool.h"


@interface YTOrderdetailController () <UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;

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
    mainView.delegate = self;
    mainView.opaque = NO;
    mainView.backgroundColor = YTGrayBackground;
    self.view = mainView;
    self.webView = mainView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.webView.scalesPageToFit = YES;
    
    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
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
                
                [MobClick event:@"orderDetail_click" attributes:@{ @"按钮" : @"报备", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            } else if ([command isEqualToString:@"jumpProduct"])
            {
                YTProductdetailController *web = [[YTProductdetailController alloc] init];
                web.url = [NSString stringWithFormat:@"%@%@", YTH5Server, urlComps[2]];
                web.proId = urlComps[3];
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }
        }
        return NO;
    }
    return YES;
}


#pragma mark - lazy

/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
