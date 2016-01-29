//
//  CustomMaskViewController.m
//  TCCloudPlayerSDKTest
//
//  Created by AlexiChen on 15/8/19.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "YTPlayerViewController.h"
#import "TCCloudPlayerVideoUrlInfo.h"
#import "YTTabBarController.h"
#import "YTAccountTool.h"
#import "UIImageView+SD.h"
#import "TCCloudPlayerSDK.h"
#import "CoreArchive.h"


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

/**
 *  蒙板
 */
@property (nonatomic, weak) UIView *ableView;


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
    
    // 开启缓存
    [TCCloudPlayerView setEnableCache:YES];
    
    // 监听播放状态
    [YTCenter addObserver:self selector:@selector(hiddenAbleView:) name:TCCloudPlayStateChangeNotification object:nil];
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
 *  设置数据
 */
- (void)setVedio:(YTVedioModel *)vedio
{
    _vedio = vedio;
    
    //初始化蒙板
    [self setupAbleView];
    
    // 初始化按钮
    [self setupBtn];
    
    
    
    // 创建容器
    UIScrollView * ContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, DeviceWidth * 0.562, DeviceWidth, DeviceHight - DeviceWidth * 0.562)];
    [self.view addSubview:ContentView];
    self.ContentView = ContentView;
    
    // 点赞按钮
    UIButton *likeBtn = [[UIButton alloc] init];
    [likeBtn setAdjustsImageWhenDisabled:NO];
    // 是否点过赞
    if (vedio.isLiked == 0) {
        [likeBtn setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
        likeBtn.enabled = YES;
    } else {
        [likeBtn setImage:[UIImage imageNamed:@"Likeanxia"] forState:UIControlStateNormal];
        likeBtn.enabled = NO;
    }
    if (vedio.likes > 0) {   // 点赞数量
        [likeBtn setTitle:[NSString stringWithFormat:@"%d", vedio.likes] forState:UIControlStateNormal];
    }
    [likeBtn setTitleColor:YTNavBackground forState:UIControlStateNormal];
    [likeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    [likeBtn sizeToFit];
    likeBtn.frame = CGRectMake(DeviceWidth - likeBtn.width - 10, 15, likeBtn.width, likeBtn.height);
    [self.ContentView addSubview:likeBtn];
    
    // 视频标题
    UILabel *title = [[UILabel alloc] init];
    title.text = vedio.videoName;
    title.textColor = YTColor(51, 51, 51);
    title.font = [UIFont systemFontOfSize:15];
    [title sizeToFit];
    CGFloat titleWidth = title.width;
    title.frame = CGRectMake(10, 15, CGRectGetMinX(likeBtn.frame) - 20, title.height);
    [self.ContentView addSubview:title];
    
    // 标题分割线
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = YTColor(208, 208, 208);
    lineView.frame = CGRectMake(10, CGRectGetMaxY(title.frame) + 10, titleWidth - 35, 1);
    [self.ContentView addSubview:lineView];
    
    // 视频简介
    UILabel *shorName = [[UILabel alloc] init];
    shorName.text = @"产品简介";
    shorName.textColor = YTColor(102, 102, 102);
    shorName.font = [UIFont systemFontOfSize:13];
    [shorName sizeToFit];
    shorName.origin = CGPointMake(10, CGRectGetMaxY(lineView.frame) + 10);
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
    
    // 第一次加载FAQ
    NSString *firstSchool = [CoreArchive strForKey:@"firstSchool"];
    if (firstSchool == nil) {
        UIButton *firstSchoolBtn = [[UIButton alloc] init];
        firstSchoolBtn.backgroundColor = [UIColor clearColor];
        [firstSchoolBtn setBackgroundImage:[UIImage imageNamed:@"zhitingbukan"] forState:UIControlStateNormal];
        firstSchoolBtn.frame = CGRectMake(0, 0, DeviceWidth, DeviceHight);
        [firstSchoolBtn addTarget:self action:@selector(firstSchoolClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:firstSchoolBtn];
    }
}

/**
 *  faq点击
 */
- (void)firstSchoolClick:(UIButton *)btn
{
    [btn removeFromSuperview];
    [CoreArchive setStr:@"FAQ" key:@"firstSchool"];
}

/**
 *  初始化蒙板
 */
- (void)setupAbleView
{
    // 容器
    UIView *content = [[UIView alloc] init];
    content.frame = [self playViewFrame];
    [self.view addSubview:content];
    self.ableView = content;
    
    // 背景图片
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.frame = [self playViewFrame];
    [imageV imageWithUrlStr:self.vedio.coverImageUrl phImage:[UIImage imageNamed:@"SchoolBanner"]];
    [content addSubview:imageV];
    
    // 菊花
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.center = content.center;
    [content addSubview:activity];
    [activity startAnimating];
}

/**
 *  隐藏蒙板
 */
- (void)hiddenAbleView:(NSNotification *)note
{
    [self.ableView removeFromSuperview];
    self.ableView = nil;
}



/**
 *  播放视频
 */
- (void)playVideo
{
    
    NSMutableArray* mutlArray = [NSMutableArray array];
    TCCloudPlayerVideoUrlInfo* info = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info.videoUrlTypeName = @"原始";
//    info.videoUrl = [NSURL URLWithString:self.vedio.SDVideoUrl];
    info.videoUrl = [NSURL URLWithString:@"http://2527.vod.myqcloud.com/2527_117134a2343111e5b8f5bdca6cb9f38c.f20.mp4"];
    [mutlArray addObject:info];
    
    TCCloudPlayerVideoUrlInfo* info1 = [[TCCloudPlayerVideoUrlInfo alloc]init];
    info1.videoUrlTypeName = @"标清";
//    info1.videoUrl = [NSURL URLWithString:self.vedio.HDVideoUrl];
    info1.videoUrl = [NSURL URLWithString:@"http://2527.vod.myqcloud.com/2527_117134a2343111e5b8f5bdca6cb9f38c.f30.mp4"];
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
        tabBar.floatView = nil;
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
- (void)likeClick:(UIButton *)likeBtn
{
    // 改变按钮状态
    [likeBtn setImage:[UIImage imageNamed:@"Likeanxia"] forState:UIControlStateNormal];
    [likeBtn setTitle:[NSString stringWithFormat:@"%d", self.vedio.likes + 1] forState:UIControlStateNormal];
    [likeBtn sizeToFit];
    likeBtn.enabled = NO;
    
    // 改变列表原数据
    if ([self.delegate respondsToSelector:@selector(likeChangData)]) {
        [self.delegate likeChangData];
    }
    
    // 发送请求
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"videoId"] = self.vedio.videoId;
    [YTHttpTool post:YTVideoLike params:param success:^(id responseObject) {
    } failure:^(NSError *error) {
    }];
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
    [self hiddenAbleView:nil];
}

@end
