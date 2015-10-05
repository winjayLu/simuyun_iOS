//
//  YTSchoolViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import "YTSchoolViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface YTSchoolViewController ()

@property (nonatomic, strong) AVAudioPlayer *avPlay;

@end

@implementation YTSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YTRandomColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [button addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    [self.view addSubview:button];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)btnClick
{

    

//        if (self.avPlay.playing) {
//            [self.avPlay stop];
//            return;
//        }
    NSString *url = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSURL *urlPlay = [NSURL URLWithString:[NSString stringWithFormat:@"%@/lll.aac",url]];
    NSString *newurl = [NSString stringWithFormat:@"%@/lll.aac",url];
    NSURL *urlPlay = [NSURL fileURLWithPath:newurl];
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
    
    self.avPlay = player;
    [self.avPlay play];

}

@end
