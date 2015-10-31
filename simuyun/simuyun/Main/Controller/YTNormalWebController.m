//
//  YTNormalWebController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTNormalWebController.h"
#import "YTAccountTool.h"



@interface YTNormalWebController ()

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
    
    // 获取当前时间
    //    [[NSDate date] stringWithFormater:@""];
    [mainView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    mainView.scalesPageToFit = YES;
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

/**
 *  清理webView缓存
 */
- (void)dealloc
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 判断当前加载成功的页面是哪个
    if ([webView.request.URL.absoluteString isEqualToString:self.url]) {
        NSString *js = [NSString stringWithFormat:@"document.getElementById('telnum').value = '%@';",[YTAccountTool account].token];
        [webView stringByEvaluatingJavaScriptFromString:js];
    }
}


@end
