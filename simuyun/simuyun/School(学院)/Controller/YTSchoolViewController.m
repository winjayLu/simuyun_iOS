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
#import "YTSchoolSubPagController.h"
#import "MJRefresh.h"
#import "NSDate+Extension.h"

@interface YTSchoolViewController () <UIWebViewDelegate>


@end

@implementation YTSchoolViewController

- (void)loadView
{
    
    // 将控制器的View替换为webView
    UIWebView *mainView = [[UIWebView alloc] initWithFrame:DeviceBounds];
    
    // 获取当前时间
//    [[NSDate date] stringWithFormater:@""];
    mainView.delegate = self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@uid=%@&v=4.0", [self appendingUrl:nil], [YTAccountTool account].userId]];
//     NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@uid=%@&v=4.0", [self appendingUrl:nil], @"6dcb3fff72f4423ca5077d0741d2e884"]];
    [mainView loadRequest:[NSURLRequest requestWithURL:url]];
    mainView.scalesPageToFit = YES;
    [mainView.scrollView setShowsVerticalScrollIndicator:NO];
    mainView.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [mainView reload];
    }];
    self.view = mainView;
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [((UIWebView *)self.view).scrollView.header endRefreshing];
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
