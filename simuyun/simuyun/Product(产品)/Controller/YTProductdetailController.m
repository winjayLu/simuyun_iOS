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
#import "UIBarButtonItem+Extension.h"
#import "DXPopover.h"

@interface YTProductdetailController ()
@property (nonatomic, weak) UIWebView *webView;

/**
 *  进度条代理
 */
@property (nonatomic, strong) YHWebViewProgress *progressProxy;

// 弹出菜单
@property (nonatomic, strong) DXPopover *popover;

// 菜单内容
@property (nonatomic, strong) UIView *innerView;
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
    
    // 右侧菜单
    [self setupRightMenu];
}

/**
 *  右侧菜单
 */
- (void)setupRightMenu
{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, 22, 22);
    [button addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
/**
 *  右侧菜单点击
 */
- (void)rightClick:(UIButton *)button
{
    if (self.popover != nil) return;
    
    DXPopover *popover = [DXPopover popover];
    self.popover = popover;
    // 修正位置
    UIView *view = [[UIView alloc] init];
    view.frame = button.frame;
    view.y = view.y - 33;
    [popover showAtView:view withContentView:self.innerView inView:self.view];
    popover.didDismissHandler = ^{
        self.innerView.layer.cornerRadius = 0.0;
        self.popover = nil;
    };
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

- (UIView *)innerView
{
    if (!_innerView) {
        UIView *view = [[UIView alloc] init];
        view.size = CGSizeMake(200, 100);
        // 分享
        UIButton *share = [[UIButton alloc] init];
        share.frame = CGRectMake(0, 0, view.width, view.height * 0.5);
        [share setBackgroundColor:YTNavBackground];
        [share setTitle:@"分享" forState:UIControlStateNormal];
        share.titleLabel.textColor = [UIColor blackColor];
        [share addTarget:self action:@selector(shareClcik) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:share];
        
        // 获取详细资料
        UIButton *getDetail = [[UIButton alloc] init];
        getDetail.frame = CGRectMake(0, share.height, share.width, share.height);
        [getDetail setBackgroundColor:YTGrayBackground];
        [getDetail setTitle:@"获取详细资料" forState:UIControlStateNormal];
        [getDetail addTarget:self action:@selector(DetailClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:getDetail];
        // 分割线
        _innerView = view;
    }
    return _innerView;
}
// 分享
- (void)shareClcik
{
    YTLog(@"ss");
    [self.popover dismiss];
    self.popover = nil;
}

// 获取详细资料
- (void)DetailClick
{
    YTLog(@"ss");
    [self.popover dismiss];
    self.popover = nil;
}


/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

@end
