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
    NSString *urls = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *urlComps = [urls componentsSeparatedByString:@":"];
    
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"app"])
    {
        // 跳转的地址和标题
        if (urlComps.count) {
            NSString *command = urlComps[1];
            if ([command isEqualToString:@"gopage"])
            {
                YTNormalWebController *normal = [[YTNormalWebController alloc] init];
                normal.url = [NSString stringWithFormat:@"%@%@", YTH5Server, urlComps[2]];
                normal.toTitle = urlComps[3];
                [self.navigationController pushViewController:normal animated:YES];
            } else if ([command isEqualToString:@"closepage"])
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    return YES;
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
