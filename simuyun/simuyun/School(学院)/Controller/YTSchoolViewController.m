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
#import "YTPlayerViewController.h"
#import "TCCloudPlayerSDK.h"
#import "TCCloudPlayerRorateViewController.h"
#import "CustomMaskViewController.h"



@interface YTSchoolViewController () <UIWebViewDelegate, UINavigationControllerDelegate>


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
//            NSString *url = [arrFucnameAndParameter[0] substringFromIndex:4];
//            NSString *title = [arrFucnameAndParameter[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            YTSchoolSubPagController *school = [[YTSchoolSubPagController alloc] init];
//            school.url = [self appendingUrl:url];
//            school.titleData = title;
//            school.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:school animated:YES];
#warning 测试
//            YTPlayerViewController *playerVc = [[YTPlayerViewController alloc] init];
//            [self presentViewController:playerVc animated:YES completion:nil];
//            NSMutableArray* mutlArray = [NSMutableArray array];
//            TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
//            info.videoUrlTypeName = @"原始";
//            info.videoUrl = [NSURL URLWithString:@"http://2527.vod.myqcloud.com/2527_2d3121ca4c9611e5b8dc613186ea171e.f30.mp4?sign=c189fc9739c5f54fec6fdd5f1b14a995&t=55efe8aa"];
//            [mutlArray addObject:info];
//            
//            TCCloudPlayerVideoUrlInfo* info1 = [[TCCloudPlayerVideoUrlInfo alloc]init];
//            info1.videoUrlTypeName = @"标清";
//            info1.videoUrl = [NSURL URLWithString:@"http://2527.vod.myqcloud.com/2527_2d3121ca4c9611e5b8dc613186ea171e.f40.mp4?sign=f70b5c3ba732683a997a8e16540a780c&t=55efe8c6"];
//            [mutlArray addObject:info1];
//            
////            [TCCloudPlayerSDK pushPlayVideo:@"testAppID"
////                                videoFileID:@"testVideoFileID"
////                                  videoName:@"侏罗纪"
////                                  videoUrls:mutlArray
////                             limitedSeconds:0
////                       defaultPlayUrlsIndex:0
////                         fromViewController:self
////                       withCustomController:[YTPlayerViewController class]
////                            inPortraitFrame:CGRectMake(0,20, DeviceWidth, DeviceWidth * 0.5625)];
////            YTPlayerViewController *player = [[YTPlayerViewController alloc] init];
////            [self.navigationController pushViewController:player animated:YES];
//            [TCCloudPlayerSDK playVideo:@"test" videoFileID:@"t" videoName:@"侏罗纪" videoUrls:mutlArray limitedSeconds:0 defaultPlayUrlsIndex:0 inViewController:self];
            
            CustomMaskViewController *test = [[CustomMaskViewController alloc] init];
            test.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:test animated:YES];
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



- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated{
    
    // 如果进入的是首页视图控制器
    if ([viewController isKindOfClass:[YTSchoolViewController class]]) {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    } else {
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}



@end
