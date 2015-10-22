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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?uid=%@&v=4.0", [self appendingUrl:nil], [YTAccountTool account].userId]];
    [mainView loadRequest:[NSURLRequest requestWithURL:url]];
    mainView.scalesPageToFit = YES;
    self.view = mainView;
    self.view.backgroundColor = YTViewBackground;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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





/**
 *  拼接地址
 */
- (NSString *)appendingUrl:(NSString *)url
{
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"http://www.simuyun.com/academy/"];
    //
    if (url != nil) {
        
        [str appendString:url];
    }
    return str;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)btnClick
{
    


}

@end
