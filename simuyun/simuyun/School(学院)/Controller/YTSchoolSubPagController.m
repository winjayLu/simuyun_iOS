//
//  YTSchoolSubPagController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/22.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTSchoolSubPagController.h"
#import "YHWebViewProgress.h"
#import "YHWebViewProgressView.h"
#import "NSDate+Extension.h"


@interface YTSchoolSubPagController () <UIWebViewDelegate>



/**
 *  进度条代理
 */
@property (nonatomic, strong) YHWebViewProgress *progressProxy;

@property (nonatomic, weak) UIWebView *webView;


@end

@implementation YTSchoolSubPagController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = DeviceBounds;
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    self.view = webView;
    self.webView = webView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"正在加载";
    self.view.userInteractionEnabled = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupProgress];
    // 加载网页
    [(UIWebView *)self.view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
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

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSString *urls = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",urls);
    NSArray *urlComps = [urlString componentsSeparatedByString:@"://"];
    //
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"objc"])
    {
        //urlString=objc://turn/topic-lister.html:/黄埔专区
        NSArray *arrFucnameAndParameter = [(NSString*)[urlComps objectAtIndex:1] componentsSeparatedByString:@":/"];
        
        // 跳转的地址和标题
        if (arrFucnameAndParameter.count) {
            NSString *url = [arrFucnameAndParameter[0] substringFromIndex:4];
            NSString *title = [arrFucnameAndParameter[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            YTSchoolSubPagController *school = [[YTSchoolSubPagController alloc] init];
            school.url = [self appendingUrl:url];
            school.titleData = title;
            school.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:school animated:YES];
        }
        
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = self.titleData;
    [self.progressProxy.progressView setProgress:1.0f animated:NO];
    self.view.userInteractionEnabled = YES;
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
    [str appendString:[NSDate stringDate]];
    return str;
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
