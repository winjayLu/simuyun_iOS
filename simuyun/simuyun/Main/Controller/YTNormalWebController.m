//
//  YTNormalWebController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTNormalWebController.h"
#import "YTAccountTool.h"
#import "NSDate+Extension.h"
#import "NSString+Password.h"
#import "YTAccountTool.h"
#import "YTReportContentController.h"
#import "YTProductModel.h"
#import "YTViewPdfViewController.h"


@interface YTNormalWebController () <UIWebViewDelegate>

@end

@implementation YTNormalWebController

+ (instancetype)webWithTitle:(NSString *)title url:(NSString *)url
{
    YTNormalWebController *normal = [[self alloc] init];
    normal.toTitle = title;
    normal.url = url;
    return normal;
}


- (void)loadView
{
    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    // 加时间戳
    if(self.isDate == NO)
    {
        NSMutableString *url = [NSMutableString string];
        [url appendString:self.url];
        [url appendString:[NSDate stringDate]];
        [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    } else {
        [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }

    mainView.scalesPageToFit = YES;
    mainView.delegate = self;
    mainView.opaque = NO;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    self.view = mainView;
    self.view.backgroundColor = YTGrayBackground;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.toTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
            if ([command isEqualToString:@"openpage"])
            {
                YTNormalWebController *normal = [[YTNormalWebController alloc] init];
                normal.url = [NSString stringWithFormat:@"%@%@", YTH5Server, urlComps[2]];
                normal.isDate = YES;
                normal.toTitle = urlComps[3];
                [self.navigationController pushViewController:normal animated:YES];
            } else if ([command isEqualToString:@"closepage"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            } else if([command isEqualToString:@"changepassword"])
            {
                [self changPasswordWithOld:urlComps[2] newPassword:urlComps[3]];
            } else if ([command isEqualToString:@"filingdata"]) // 报备
            {
                YTReportContentController *report = [[YTReportContentController alloc] init];
                YTProductModel *product = [[YTProductModel alloc] init];
                product.order_id = urlComps[2];
                product.order_code = urlComps[3];
                product.customerName = urlComps[4];
                product.buyMoney = [urlComps[5] intValue];
                product.pro_name = urlComps[6];
                report.prouctModel = product;
                [self.navigationController pushViewController:report animated:YES];
            } else if ([command isEqualToString:@"viewpdf"])
            {
                YTViewPdfViewController *viewPdf = [[YTViewPdfViewController alloc] init];
                viewPdf.url = urlComps[2];
                viewPdf.shareTitle = urlComps[3];
                [self.navigationController pushViewController:viewPdf animated:YES];
            }
        }
        return NO;
    }
    return YES;
}


// 修改密码
- (void)changPasswordWithOld:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"password"] = [NSString md5:oldPassword];
    param[@"newPassword"] = [NSString md5:newPassword];
    [YTHttpTool post:YTUpdatePassword params:param success:^(id responseObject) {
        // 执行js代码
        NSString *js = @"setData()";
        [(UIWebView *)self.view stringByEvaluatingJavaScriptFromString:js];
        YTAccount *account = [YTAccountTool account];
        account.password = [NSString md5:newPassword];
        [YTAccountTool save:account];
    } failure:^(NSError *error) {
        NSString *js = @"setData('failure')";
        [(UIWebView *)self.view stringByEvaluatingJavaScriptFromString:js];
    }];

}


/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}




@end
