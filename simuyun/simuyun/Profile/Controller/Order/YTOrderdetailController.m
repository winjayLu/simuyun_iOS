//
//  YTOrderdetailController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTOrderdetailController.h"
//#import "YHWebViewProgress.h"
//#import "YHWebViewProgressView.h"
#import "YTReportContentController.h"
#import "YTProductModel.h"
#import "YTNormalWebController.h"
#import "YTUserInfoTool.h"
#import "YTProductdetailController.h"
#import "YTAccountTool.h"


@interface YTOrderdetailController () <UIWebViewDelegate>
@property (nonatomic, weak) UIWebView *webView;


/**
 *  产品详情控制器
 */
@property (nonatomic, strong) YTProductdetailController *proDetail;

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
    
    // 获取对应的产品详情
    [self loadProduct];
}


- (void)loadProduct
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"proId"] = self.order.product_id;
    [YTHttpTool get:YTProductList params:param success:^(id responseObject) {
        NSArray *products = [YTProductModel objectArrayWithKeyValuesArray:responseObject];
        if (products.count > 0) {
            self.proDetail.product = products[0];
        }
    } failure:^(NSError *error) {
    }];
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
            } else if ([command isEqualToString:@"openpage"])
            {
                self.proDetail.url = [NSString stringWithFormat:@"%@%@", YTH5Server, urlComps[2]];
                [self.navigationController pushViewController:self.proDetail animated:YES];
            }
        }
        return NO;
    }
    return YES;
}


#pragma mark - lazy

- (YTProductdetailController *)proDetail
{
    if (!_proDetail) {
        _proDetail = [[YTProductdetailController alloc] init];
    }
    return _proDetail;
}

/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
