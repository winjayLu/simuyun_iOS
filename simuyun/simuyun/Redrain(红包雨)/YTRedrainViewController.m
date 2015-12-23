//
//  YTRedrainViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/31.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTRedrainViewController.h"

@interface YTRedrainViewController () <UIWebViewDelegate>

@end

@implementation YTRedrainViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    
    // 获取当前时间
    [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    mainView.scalesPageToFit = YES;
    mainView.delegate = self;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    mainView.opaque = NO;
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    
    [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}



- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    NSString *urls = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (urls != nil && ![urls isEqualToString:self.url]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
