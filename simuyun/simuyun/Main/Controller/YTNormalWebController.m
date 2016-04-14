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
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "YTOrderdetailController.h"
#import "YTProductdetailController.h"
#import "YTOrderCenterController.h"


@interface YTNormalWebController () <UIWebViewDelegate>

/**
 *  进度条代理
 */
@property (nonatomic, strong) YHWebViewProgress *progressProxy;

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
    // 是否显示进度条
    if (!self.isProgress) {
        self.title = @"正在加载";
        [self setupProgress];
    } else {
        self.title = self.toTitle;
    }
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
    progressView.progressBarColor = YTRGBA(0, 0, 0, 0.7);
    // 设置进度条
    self.progressProxy.progressView = progressView;
    // 将UIWebView代理指向YHWebViq   ewProgress
    ((UIWebView *)self.view).delegate = self.progressProxy;
    // 设置webview代理转发到self
    self.progressProxy.webViewProxy = self;
    // 添加到视图
    [self.view addSubview:progressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progressProxy.progressView setProgress:1.0f animated:NO];
    
    self.title = self.toTitle;
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    self.progressProxy.progressView.hidden = YES;
    self.title = @"加载失败";
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
            } else if ([command isEqualToString:@"closepage"])  // 关闭页面
            {
                [self.navigationController popViewControllerAnimated:YES];
            } else if([command isEqualToString:@"changepassword"])  // 修改密码
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
            } else if ([command isEqualToString:@"viewpdf"])    // pdf浏览
            {
                YTViewPdfViewController *viewPdf = [[YTViewPdfViewController alloc] init];
                viewPdf.url = urlComps[2];
                viewPdf.shareTitle = urlComps[3];
                
                [self.navigationController pushViewController:viewPdf animated:YES];
            } else if ([command isEqualToString:@"jumpProduct"])
            {
                YTProductdetailController *web = [[YTProductdetailController alloc] init];
                web.url = [NSString stringWithFormat:@"%@%@", YTH5Server, urlComps[2]];
                web.proId = urlComps[3];
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            } else if ([command isEqualToString:@"custbyorder"])
            {
                YTOrderCenterController *order = [[YTOrderCenterController alloc] init];
                order.custId = urlComps[2];
                order.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:order animated:YES];
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

#pragma mark - lazy

- (YHWebViewProgress *)progressProxy
{
    if (!_progressProxy) {
        _progressProxy = [[YHWebViewProgress alloc] init];
    }
    return _progressProxy;
}




@end
