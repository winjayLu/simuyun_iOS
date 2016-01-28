//
//  YTSchoolViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTSchoolViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "HHAlertView.h"
#import "YTProfileTopView.h"
#import "YTAccountTool.h"
#import "NSDate+Extension.h"
#import "MJRefresh.h"
#import "NSDate+Extension.h"
#import "YTPlayerViewController.h"
#import "TCCloudPlayerSDK.h"
#import "TCCloudPlayerRorateViewController.h"
#import "YTPlayerViewController.h"
#import "YTTabBarController.h"



@interface YTSchoolViewController () <UIWebViewDelegate>


@end

@implementation YTSchoolViewController

- (void)loadView
{
    self.navigationController.delegate = self;
    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    

    mainView.delegate = self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@uid=%@&v=4.0", [self appendingUrl:nil], [YTAccountTool account].userId]];
    [mainView loadRequest:[NSURLRequest requestWithURL:url]];
    mainView.scalesPageToFit = YES;
    mainView.opaque = NO;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    mainView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [mainView reload];
    }];
    self.view = mainView;
    self.view.backgroundColor = [UIColor whiteColor];

}


- (void)viewWillAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = NO;
    [super viewWillAppear:animated];
    [MobClick event:@"nav_click" attributes:@{@"按钮" : @"学院"}];
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

#warning 测试

            UIWindow *keyWindow = nil;
            for (UIWindow *window in [UIApplication sharedApplication].windows) {
                if (window.windowLevel == 0) {
                    keyWindow = window;
                    break;
                }
            }
            
            
            UIViewController *appRootVC = keyWindow.rootViewController;
            if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
                YTTabBarController *tabBar = ((YTTabBarController *)appRootVC);
                FloatView *floatView = tabBar.floatView;
                UIViewController *keyVc = ((UITabBarController *)appRootVC).selectedViewController;
                if (keyVc != nil) {
                    [floatView removeFloatView];
                    tabBar.playerVc = nil;
                    tabBar.floatView = nil;
                }
            }
            
            YTPlayerViewController *test = [[YTPlayerViewController alloc] init];
            [self presentViewController:test animated:YES completion:nil];
//            test.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:test animated:YES];
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView.header endRefreshing];
    // 禁用用户选择
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    // 禁用长按弹出框
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [((UIWebView *)self.view).scrollView.header endRefreshing];
}


/**
 *  拼接地址
 */
- (NSString *)appendingUrl:(NSString *)url
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"http://www.simuyun.com/academy"];
    if (url != nil) {
        
        [str appendString:url];
    }
    [str appendString:[NSDate stringDate]];
    return str;
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






@end
