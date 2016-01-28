//
//  CustomMaskViewController.m
//  TCCloudPlayerSDKTest
//
//  Created by AlexiChen on 15/8/19.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "YTPlayerViewController.h"
#import "TCCloudPlayerVideoUrlInfo.h"
#import "YTSchoolViewController.h"
#import "YTTabBarController.h"


@interface YTPlayerViewController ()

/**
 *  内容容器
 */
@property (nonatomic, weak) UIScrollView *ContentView;

/**
 *  关闭按钮
 */
@property (nonatomic, weak) UIButton *closeBtn;

/**
 *  最小化按钮
 */
@property (nonatomic, weak) UIButton *hiddenBtn;


@end

@implementation YTPlayerViewController

- (CGRect)playViewFrame
{
    return CGRectMake(0 , 0, DeviceWidth, DeviceWidth * 0.5625);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self playVideo];
    // 初始化按钮
    [self setupBtn];
    // 初始化内容视图
    [self setupContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}

/**
 *  初始化按钮
 */
- (void)setupBtn
{
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"schoolFanhui"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"schoolFanhuianxia"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(10, 27, closeBtn.currentBackgroundImage.size.width, closeBtn.currentBackgroundImage.size.height);
    [self.view addSubview:closeBtn];
    self.closeBtn = closeBtn;
    
    UIButton *hiddenBtn = [[UIButton alloc] init];
    [hiddenBtn setBackgroundImage:[UIImage imageNamed:@"zuixiaohua"] forState:UIControlStateNormal];
    [hiddenBtn setBackgroundImage:[UIImage imageNamed:@"zuixiaohuaanxia"] forState:UIControlStateHighlighted];
    [hiddenBtn addTarget:self action:@selector(hiddenClick) forControlEvents:UIControlEventTouchUpInside];
    hiddenBtn.frame = CGRectMake(DeviceWidth - 10 - hiddenBtn.currentBackgroundImage.size.width, 27, hiddenBtn.currentBackgroundImage.size.width, hiddenBtn.currentBackgroundImage.size.height);
    [self.view addSubview:hiddenBtn];
    self.hiddenBtn = hiddenBtn;
}

/**
 *  初始化内容视图
 */
- (void)setupContent
{
   
}

/**
 *  设置数据
 */
- (void)setVedio:(YTVedioModel *)vedio
{
    _vedio = vedio;
    
    // 创建容器
    UIScrollView * ContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DeviceWidth * 0.562, DeviceWidth, DeviceHight - DeviceWidth * 0.562)];
    [self.view addSubview:ContentView];
    self.ContentView = ContentView;
    
    // 点赞按钮
    UIButton *likeBtn = [[UIButton alloc] init];
    // 是否点过赞
    if (vedio.isLiked == 0) {
        [likeBtn setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
    } else {
        [likeBtn setImage:[UIImage imageNamed:@"Likeanxia"] forState:UIControlStateNormal];
    }
    if (vedio.likes > 0) {   // 点赞数量
        [likeBtn setTitle:[NSString stringWithFormat:@"%d", vedio.likes] forState:UIControlStateNormal];
    }
    [likeBtn setTitleColor:YTNavBackground forState:UIControlStateNormal];
    [likeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [likeBtn sizeToFit];
    likeBtn.frame = CGRectMake(DeviceWidth - likeBtn.width - 10, 15, likeBtn.width, likeBtn.height);
    [self.ContentView addSubview:likeBtn];
    
    // 视频标题
    UILabel *title = [[UILabel alloc] init];
    title.text = vedio.videoName;
    title.textColor = YTColor(51, 51, 51);
    title.font = [UIFont systemFontOfSize:15];
    [title sizeToFit];
    title.frame = CGRectMake(10, 15, CGRectGetMinX(likeBtn.frame) - 20, title.height);
    [self.ContentView addSubview:title];
    
    // 视频简介
    UILabel *shorName = [[UILabel alloc] init];
    shorName.text = @"产品简介";
    shorName.textColor = YTColor(102, 102, 102);
    shorName.font = [UIFont systemFontOfSize:13];
    [shorName sizeToFit];
    shorName.origin = CGPointMake(10, CGRectGetMaxY(title.frame) + 20);
    [self.ContentView addSubview:shorName];
    
    // 视频简介
    UILabel *detail = [[UILabel alloc] init];
    detail.text = vedio.videoSummary;
    detail.font = [UIFont systemFontOfSize:13];
    detail.textColor = YTColor(102, 102, 102);
    detail.numberOfLines = 0;
    detail.width = DeviceWidth - 20;
    [detail sizeToFit];
    detail.origin = CGPointMake(10, CGRectGetMaxY(shorName.frame) + 5);
    [self.ContentView addSubview:detail];
    
    self.ContentView.contentSize = CGSizeMake(DeviceWidth, CGRectGetMaxY(detail.frame));
}

/**
 *  播放视频
 */
- (void)playVideo
{
    
    NSMutableArray* mutlArray = [NSMutableArray array];
    TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info.videoUrlTypeName = @"原始";
    info.videoUrl = [NSURL URLWithString:self.vedio.SDVideoUrl];
    [mutlArray addObject:info];
    
    TCCloudPlayerVideoUrlInfo* info1 = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info1.videoUrlTypeName = @"标清";
    info1.videoUrl = [NSURL URLWithString:self.vedio.HDVideoUrl];
    [mutlArray addObject:info1];
    
    [self loadVideoPlaybackView:mutlArray defaultPlayIndex:0 startTime:0];
}



#pragma mark - buttonClick

/**
 *  关闭
 */
- (void)closeClick
{
    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
        tabBar.playerVc = nil;
    }
}

/**
 *  隐藏
 */
- (void)hiddenClick
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // 获取根控制器
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            keyWindow = window;
            break;
        }
    }
    // 如果获取不到直接返回
    if (keyWindow == nil) return;
    
    UIViewController *appRootVC = keyWindow.rootViewController;
    if ([appRootVC isKindOfClass:[YTTabBarController class]]) {
        ((YTTabBarController *)appRootVC).playerVc = self;
        if (((YTTabBarController *)appRootVC).floatView == nil)
        {
            ( (YTTabBarController *)appRootVC).floatView = [FloatView defaultFloatViewWithButton];
        } else {
            ((YTTabBarController *)appRootVC).floatView.boardWindow.hidden = NO;
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/**
 *  点赞
 */
- (void)likeClick
{
    NSLog(@"点赞");
}

/**
 *  横屏隐藏界面
 *
 */
- (void)changeContentView:(BOOL)isShow
{
    self.ContentView.hidden = isShow;
    self.hiddenBtn.hidden = isShow;
    self.closeBtn.hidden = isShow;
}

@end
