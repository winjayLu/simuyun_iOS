//
//  YTPlayerViewController.m
//  simuyun
//
//  Created by Luwinjay on 16/1/25.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTPlayerViewController.h"
#import "TCCloudPlayerView.h"


@interface YTPlayerViewController ()
//@property (nonatomic, strong) TCCloudPlayerView *playerView;

@end

@implementation YTPlayerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeContactAdd];
    
    // 修改全屏非全屏图片
     [_playbackView changeBottomFullImage:[UIImage imageNamed:@"jiahao"] notFullImage:[UIImage imageNamed:@"guanyu"]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    butt.frame = CGRectMake(100, 400, 40, 40);
    [butt addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];
    
    
    
    __weak typeof(self) ws = self;
    _playbackView.playbackBeginBlock = ^(void){
//        [ws playbackBeginBlock];
               NSLog(@"test");
    };
    
    _playbackView.playbackFailedBlock = ^(NSError* error){
//        [ws playbackFailedBlock:error];
               NSLog(@"test");
    };
    _playbackView.playbackEndBlock = ^(void){
//        [ws playbackEndBlock];
               NSLog(@"test");
    };
    _playbackView.playbackPauseBlock = ^(UIImage* curImg, TCCloudPlayerPauseReason reason){
//        [ws playbackPauseBlock:curImg pauseReason:reason];
               NSLog(@"test");
    };
    
    _playbackView.singleClickblock = ^ (BOOL isInFullScreen) {
        NSLog(@"test");
//        if (ws.navigationController.topViewController == ws)
//        {
//            [[UIApplication sharedApplication] setStatusBarHidden:isInFullScreen withAnimation:UIStatusBarAnimationSlide];
//            [ws.navigationController setNavigationBarHidden:isInFullScreen animated:YES];
//        }
        
    };
    
    _playbackView.clickPlaybackViewblock = ^ (BOOL isFullScreen) {
               NSLog(@"test");
//        if (isFullScreen)
//        {
//            NSLog(@"当前是全屏");
//        }
//        else
//        {
//            NSLog(@"当前不是全屏");
//        }
    };
    
    _playbackView.enterExitFullScreenBlock = ^ (BOOL enterFullScreen) {
               NSLog(@"test");
//        if (ws.navigationController.topViewController == ws)
//        {
//            [[UIApplication sharedApplication] setStatusBarHidden:enterFullScreen withAnimation:UIStatusBarAnimationSlide];
//            [ws.navigationController setNavigationBarHidden:enterFullScreen animated:YES];
//            if (enterFullScreen)
//            {
//                NSLog(@"进入全屏");
//            }
//            else
//            {
//                NSLog(@"退出全屏");
//            }
//        }
    };

}

- (void)btnClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
