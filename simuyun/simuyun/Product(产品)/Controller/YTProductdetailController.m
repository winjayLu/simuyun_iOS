//
//  YTProductdetailController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTProductdetailController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"

@interface YTProductdetailController ()
@property (nonatomic, weak) UIWebView *webView;

/**
 *  进度条代理
 */
@property (nonatomic, strong) YHWebViewProgress *progressProxy;
@end

@implementation YTProductdetailController

- (void)loadView
{
    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    
    // 获取当前时间
    //    [[NSDate date] stringWithFormater:@""];
    [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    mainView.scalesPageToFit = YES;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    self.view = mainView;
    self.webView = mainView;
    self.view.backgroundColor = YTGrayBackground;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品详情";
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
    // 将UIWebView代理指向YHWebViq   ewProgress
    self.webView.delegate = self.progressProxy;
    // 设置webview代理转发到self
//    self.progressProxy.webViewProxy = self;
    // 添加到视图
    [self.view addSubview:progressView];
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSString *urls = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urls);
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    //
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        
        // 跳转的地址和标题
        if (arrFucnameAndParameter.count) {
            NSString *url = [arrFucnameAndParameter[0] substringFromIndex:4];

//            YTWebViewController *vc = [[YTWebViewController alloc] init];
//            vc.url = [self appendingUrl:url];
            
//            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    return YES;
}


/**
 *  拼接地址
 */
- (NSString *)appendingUrl:(NSString *)url
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"http://www.simuyun.com/academy/"];
    if (url != nil) {
        
        [str appendString:url];
    }
    return str;
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
