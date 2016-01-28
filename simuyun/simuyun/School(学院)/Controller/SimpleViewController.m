//
//  SimpleViewController.m
//  TCCloudPlayerSDKTest
//
//  Created by AlexiChen on 15/8/13.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import "SimpleViewController.h"

#import "TCCloudPlayerSDK.h"

#import "TCReportEngine.h"

@interface SimpleViewController ()
{
    CGFloat _limitedSeconds;
}

@end

@implementation SimpleViewController

- (BOOL)prefersStatusBarHidden
{
    UIInterfaceOrientation ort = [UIApplication sharedApplication].statusBarOrientation;

    return !UIInterfaceOrientationIsPortrait(ort);
}

- (CGRect)playViewFrame
{
    return CGRectMake(0 , 20, DeviceWidth, DeviceWidth * 0.5625);
}

- (void)addPlayerView
{
    
    _playerView = [[TCCloudPlayerView alloc] initWithNotFullFrame:[self playViewFrame]];
    [self.view addSubview:_playerView];
    [_playerView changeBottomFullImage:[UIImage imageNamed:@"jiahao"] notFullImage:[UIImage imageNamed:@"guanyu"]];
    
    __weak typeof(self) ws = self;
    //    _playerView.playbackReadyBlock = ^(void){
    //        [ws playbackReadyBlock];
    //    };
    _playerView.playbackBeginBlock = ^(void){
        [ws playbackBeginBlock];
    };
    
    _playerView.playbackFailedBlock = ^(NSError* error){
        [ws playbackFailedBlock:error];
    };
    _playerView.playbackEndBlock = ^(void){
        [ws playbackEndBlock];
    };
    _playerView.playbackPauseBlock = ^(UIImage* curImg, TCCloudPlayerPauseReason reason){
        [ws playbackPauseBlock:curImg pauseReason:reason];
    };
    
//    _playerView.singleClickblock = ^ (BOOL isInFullScreen) {
//
//        if (isInFullScreen) {
////            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
//        }
//
//    };
//    
//    _playerView.clickPlaybackViewblock = ^ (BOOL isFullScreen) {
//        if (isFullScreen)
//        {
//            NSLog(@"当前是全屏");
//        }
//        else
//        {
//            NSLog(@"当前不是全屏");
//        }
//    };
    
    _playerView.enterExitFullScreenBlock = ^ (BOOL enterFullScreen) {

        if (enterFullScreen) {
            // 隐藏视频介绍
            [ws changeContentView:YES];
            NSLog(@"进入全屏");
        } else {
            // 显示视频介绍
            [ws changeContentView:NO];
            NSLog(@"退出全屏");
        }
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addPlayerView];
}




-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self loadVideoPlaybackView:_videoUrls defaultPlayIndex:_defPlayIndex startTime:_startTimeInSeconds];
}
//#pragma mark
//#pragma mark - Rotation
//#pragma mark
- (BOOL)shouldAutorotate
{
    return YES;
}

 

#pragma mark
#pragma mark 加载视频播放及回调
#pragma mark
-(void)loadVideoPlaybackView:(NSArray*)videoUrls defaultPlayIndex:(NSUInteger)defaultPlayIndex startTime:(Float64)startTimeInSeconds
{
    _playerView.isSilent = NO;
    _playerView.isCyclePlay = NO;
    
    
    
    BOOL loadVideoRet = [_playerView setUrls:videoUrls defaultPlayIndex:defaultPlayIndex startTime:startTimeInSeconds];
    //BOOL loadVideoRet = [_playerView setAVAsset:self.videoAsset startTime:[self.startTimeValue CMTimeValue]];
    if (!loadVideoRet) {
        //[[QQProgressHUD sharedInstance] showState:@"视频加载失败" success:NO];
        
    }
    
}

//注意，退后台进入前台也会进入这个函数
- (void)playbackReadyBlock
{
    [_playerView setLimitTime:_limitedSeconds];
//    [_playerView play];
}

-(void) playbackBeginBlock
{
    if (!_playerView.isInFullScreen)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView performSelector:@selector(reversionFullScreenState) withObject:nil afterDelay:0];
    }
    
    [self postPlayNotificaction];
}

-(void) playbackFailedBlock:(NSError*)error
{
    if (_playerView.isInFullScreen) {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView reversionFullScreenState];
    }
    
    NSString* strTile = [NSString stringWithFormat:@"视频播放失败(%zd)",[error code]];
    NSString* errorDes = nil;
    //#if DEBUG
    errorDes = [error localizedDescription];
    //#endif
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTile message:errorDes delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    //显示AlertView
    [alert show];
    
    [self postStopNotificationWithError:error];
}

-(void) playbackPauseBlock:(UIImage*)curImg pauseReason:(TCCloudPlayerPauseReason)reason
{
    [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
    if (_playerView.isInFullScreen)
    {
        [_playerView reversionFullScreenState];
    }
    
    [self postPauseNotificationWithReason:reason];
}

-(void) playbackEndBlock
{
  
    
    if (_playerView.isInFullScreen)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:_playerView selector:@selector(reversionFullScreenState) object:nil];
        [_playerView reversionFullScreenState];
    }
    [self postStopNotificationWithError:nil];
}


#pragma mark - 抛通知 -

- (NSMutableDictionary *)commVideoParam
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@([_playerView getCurVideoPlaybackTimeInSeconds]) forKey:kTCCloudPlayTime];
    [param setObject:@(_playerView.duration) forKey:kTCCloudPlayDuration];
    TCCloudPlayerVideoUrlInfo *url = [_playerView currentUrl];
    if (url) {
        [param setObject:url forKey:kTCCloudPlayQaulity];
    }
    return param;
}

- (void)postPlayNotificaction
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(1) forKey:kTCCloudPlayState];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}

- (void)postPauseNotificationWithReason:(TCCloudPlayerPauseReason)reason
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(2) forKey:kTCCloudPlayState];
    [param setObject:@(reason) forKey:kTCCloudPlayPauseReason];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}

- (void)postStopNotificationWithError:(NSError *)error
{
    NSMutableDictionary *param = [self commVideoParam];
    [param setObject:@(0) forKey:kTCCloudPlayState];
    if (error) {
        [param setObject:error forKey:kTCCloudPlayError];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TCCloudPlayStateChangeNotification object:nil userInfo:param];
}



@end
