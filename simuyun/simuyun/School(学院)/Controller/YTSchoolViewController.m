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

@interface YTSchoolViewController () <iconPhotoDelegate>

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
    
    YTProfileTopView *topView = [YTProfileTopView profileTopView];
    topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    topView.delegate = self;
    [topView setIconImageWithImage:nil];
    [self.view addSubview:topView];
    
    
}

//实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (void)btnClick
{
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleDefault inView:self.view Title:@"温馨提示" detail:@"圣诞节撒了放假啦十几分考虑时间啊圣诞节撒了放假啦十几分考虑时间啊圣诞节撒了放假啦十几分考虑时间啊圣诞节撒了放撒了放圣诞节撒了放假啦十几分考虑时间啊圣" cancelButton:@"取消" Okbutton:@"去看看" block:^(HHAlertButton buttonindex) {
        
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
