//
//  SimpleViewController.h
//  TCCloudPlayerSDKTest
//
//  Created by AlexiChen on 15/8/13.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCCloudPlayerView.h"

@interface SimpleViewController : UIViewController
{
    
@protected
    TCCloudPlayerView *_playerView;
}

- (CGRect)playViewFrame;
-(void)loadVideoPlaybackView:(NSArray*)videoUrls defaultPlayIndex:(NSUInteger)defaultPlayIndex startTime:(Float64)startTimeInSeconds;

/**
 *  隐藏/显示视频介绍
 */
- (void)changeContentView:(BOOL)isShow;

@end
