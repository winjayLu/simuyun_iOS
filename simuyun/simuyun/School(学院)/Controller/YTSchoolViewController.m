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
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleDefault inView:self.view Title:@"温馨提示" detail:@"圣诞节撒了放假啦十几分考虑时间啊圣诞节撒了放假啦十几分考虑时间啊圣诞节撒了放假啦十几分考虑时间啊圣诞节撒了放撒了放圣诞节撒了放假啦十几分考虑时间啊圣诞节时间啊圣诞节撒了放假啦十几分考虑时间啊圣诞节撒了放撒了放圣诞节撒了放假啦十几分考虑时间啊圣诞节时间啊圣诞节撒了放假啦十几分考虑时间啊圣诞节撒了放撒了放圣诞节撒了放假啦十几分考虑时间啊圣诞节" cancelButton:@"取消" Okbutton:@"去看看" block:^(HHAlertButton buttonindex) {
        
        NSLog(@"%zd",buttonindex);
    }];
    

//        if (self.avPlay.playing) {
//            [self.avPlay stop];
//            return;
//        }
//    NSString *url = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
////    NSURL *urlPlay = [NSURL URLWithString:[NSString stringWithFormat:@"%@/lll.aac",url]];
//    NSString *newurl = [NSString stringWithFormat:@"%@/lll.aac",url];
//    NSURL *urlPlay = [NSURL fileURLWithPath:newurl];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:urlPlay error:nil];
//    
//    self.avPlay = player;
//    [self.avPlay play];

}

@end
