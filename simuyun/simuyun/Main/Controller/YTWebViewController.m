//
//  YTWebViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/8.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTWebViewController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "NSDate+Extension.h"


@interface YTWebViewController () <UIWebViewDelegate>
/**
 *  webView
 */
@property (weak, nonatomic) IBOutlet UIWebView *webView;



/**
 *  进度条代理
 */
@property (nonatomic, strong) YHWebViewProgress *progressProxy;

@end

@implementation YTWebViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.backgroundColor = YTGrayBackground;
    self.webView.scalesPageToFit = YES;
    // 设置标题
    if(self.toTitle == nil)
    {
        self.title = @"正在加载";
    } else {
        self.title = self.toTitle;
    }
    
    
    // 初始化进度条
    [self setupProgress];
    
    // 加时间戳
    NSMutableString *url = [NSMutableString string];
    [url appendString:self.url];
    [url appendString:[NSDate stringDate]];
    
    // 加载网页
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
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
    self.progressProxy.webViewProxy = self;
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
            // 标题
            NSString *title = [arrFucnameAndParameter[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            YTLog(@"%@",title);
            YTWebViewController *vc = [[YTWebViewController alloc] init];
            vc.url = [self appendingUrl:url];

            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = self.toTitle;
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
