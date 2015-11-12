//
//  YTLogoView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTLogoView.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "MBProgressHUD+WJ.h"

#define miniSecond 2.0f

@interface YTLogoView()

/**
 *  是否正在录音
 */
@property (nonatomic, assign) BOOL isTape;
/**
 *  录音存储地址
 */
@property (nonatomic, strong) NSURL *urlPlay;
/**
 *  录音对象
 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  logo 按钮
 */
@property (nonatomic, weak) UIButton *logoButton;

// logo 背景图片
@property (nonatomic, weak) UIImageView *bgView;

//// logo 背景图片
//@property (nonatomic, weak) UIImageView *bgView2;
//
//@property (nonatomic, assign) BOOL isBig;


@end

@implementation YTLogoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 初始化录音配置
        [self setupAudio];
        // 初始化按钮
        [self setupLogoBtn];
#warning logo呼吸
        //设置定时检测
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(scaleLogo) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)scaleLogo
{
//    if (self.isBig) {
//        [UIView animateWithDuration:0.8 animations:^{
//            self.bgView.transform = CGAffineTransformScale(self.bgView.transform,1.1, 1.1);
//        }];
//        self.isBig = NO;
//    } else {
//        [UIView animateWithDuration:0.8 animations:^{
//            self.bgView.transform = CGAffineTransformIdentity;
//        }];
//        self.isBig = YES;
//    }
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         self.transform = CGAffineTransformScale(self.transform, 0, 10);
//    });
    
//    if (self.isBig) {
//        self.isBig = NO;
//        [UIView animateWithDuration:1.4 animations:^{
//            self.bgView.hidden = NO;
//            self.bgView.transform = CGAffineTransformScale(self.bgView.transform,1.2, 1.2);
//        } completion:^(BOOL finished) {
//            self.bgView2.hidden = NO;
////            self.bgView.transform = CGAffineTransformIdentity;
//        }];
//        
//    } else {
//        self.isBig = YES;
//        [UIView animateWithDuration:1.4 animations:^{
//            self.bgView2.hidden = NO;
//            self.bgView2.transform = CGAffineTransformScale(self.bgView2.transform,1.2, 1.2);
//        } completion:^(BOOL finished) {
//            
//            self.bgView.hidden = NO;
////            self.bgView2.transform = CGAffineTransformIdentity;
//        }];
//        
//    }
    
    
//    [UIView animateWithDuration:1.4 animations:^{
//        self.bgView.transform = CGAffineTransformScale(self.bgView.transform,1.2, 1.2);
//    } completion:^(BOOL finished) {
//
//        self.bgView.transform = CGAffineTransformIdentity;
//    }];
    [UIView animateWithDuration:1.4 animations:^{
        self.bgView.alpha = 1.0;
//        self.bgView.hidden = 
        self.bgView.transform = CGAffineTransformScale(self.bgView.transform,1.1, 1.1);
    } completion:^(BOOL finished) {
        self.bgView.alpha = 0.0;
        self.bgView.transform = CGAffineTransformIdentity;
    }];
}


/**
 *  logo按钮的单击事件
 */
- (void)logoClick
{

    // 调用代理方法
    if ([self.delegate respondsToSelector:@selector(logoViewDidSelectProfileItem)]) {
        [self.delegate logoViewDidSelectProfileItem];
    }
}

/**
 *  logo按钮的长按事件
 */
- (void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer
{
    // 第一次运行会提示，是否允许使用麦克风
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // 检测是否可以录音
    if(session == nil) return;
    [session setActive:YES error:nil];
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // 开始录音
        if(self.isTape) return;// 正在录音
        self.isTape = YES;
        //创建录音文件，准备录音
        if ([self.recorder prepareToRecord]) {
            //开始
            [self.recorder record];
        }
        [MBProgressHUD showAudio];
        //设置定时检测
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
        
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {

        // 结束录音
        self.isTape = NO;
        double cTime = self.recorder.currentTime;
        [MBProgressHUD hidAudio];
        if (cTime > miniSecond) {   // 时间是否够长
            [SVProgressHUD showSuccessWithStatus:@"消息已发出"];
            
            // 读取二进制音频文件
//            NSData *audio = [NSData dataWithContentsOfURL:self.urlPlay];
        }else {
            //删除记录的文件
            [self.recorder deleteRecording];
            //删除存储的
            [SVProgressHUD showErrorWithStatus:@"说话时间太短"];
        }
        [self.recorder stop];
        [self.timer invalidate];
    }
}

/**
 *  取消录音
 *
 */
- (void)recorderCancel
{
    self.isTape = NO;
    [MBProgressHUD hidAudio];
    [self.recorder stop];
    [self.timer invalidate];
}


/**
 *  根据分贝 切换对应图片
 */
- (void)detectionVoice
{
    // 刷新音量数据
    [self.recorder updateMeters];
    
    // 获取音量的最大值
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    NSString *image = nil;
    if (0<lowPassResults<=0.06) {
        image = @"record_animate_01";
    }else if (0.06<lowPassResults<=0.13) {
        image = @"record_animate_02";
    }else if (0.13<lowPassResults<=0.20) {
        image = @"record_animate_03";
    }else if (0.20<lowPassResults<=0.27) {
        image = @"record_animate_04";
    }else if (0.27<lowPassResults<=0.34) {
        image = @"record_animate_05";
    }else if (0.34<lowPassResults<=0.41) {
        image = @"record_animate_06";
    }else if (0.41<lowPassResults<=0.48) {
        image = @"record_animate_07";
    }else if (0.48<lowPassResults<=0.55) {
        image = @"record_animate_08";
    }else if (0.55<lowPassResults<=0.62) {
        image = @"record_animate_09";
    }else if (0.62<lowPassResults<=0.69) {
        image = @"record_animate_10";
    }else if (0.69<lowPassResults<=0.76) {
        image = @"record_animate_11";
    }else if (0.76<lowPassResults<=0.83) {
        image = @"record_animate_12";
    }else if (0.83<lowPassResults<=0.9) {
        image = @"record_animate_13";
    }else {
        image = @"record_animate_14";
    }
    // 修改指示器中的图片
    [MBProgressHUD setImageName:image];
}


#pragma mark - 初始化方法
/**
 *  初始化logo按钮
 */
- (void)setupLogoBtn
{
    // logo按钮
    UIButton *logoButton = [[UIButton alloc] init];
    [logoButton setBackgroundImage:self.logoImage forState:UIControlStateNormal];
    [logoButton setBackgroundImage:self.logoImage forState:UIControlStateHighlighted];
    // 按钮单击事件
    [logoButton addTarget:self action:@selector(logoClick) forControlEvents:UIControlEventTouchUpInside];
    logoButton.size = self.logoImage.size;
    
    // 背景图片1
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"shuibowen"];
    bgView.size = logoButton.size;
    [self addSubview:bgView];
    self.bgView = bgView;
    
//    // 背景图片2
//    UIImageView *bgView2 = [[UIImageView alloc] init];
//    bgView2.image = [UIImage imageNamed:@"shuibowen"];
//    bgView2.size = logoButton.size;
//    bgView2.hidden = YES;
//    [self addSubview:bgView2];
//    self.bgView2 = bgView2;

    // 移出按钮范围事件
//    [logoButton addTarget:self action:@selector(logoExit) forControlEvents:UIControlEventTouchDragExit];
    
    [self addSubview:logoButton];
    self.logoButton = logoButton;
    // 添加logo按钮的长按事件
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
//    longPress.minimumPressDuration = 1; //定义按的时间
//    [logoButton addGestureRecognizer:longPress];
}

- (void)btnDragged:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 25.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        BOOL previewTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchInside) {
            // UIControlEventTouchDragExit
        } else {
            // UIControlEventTouchDragOutside
        }
    } else {
        BOOL previewTouchOutside = !CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchOutside) {
            // UIControlEventTouchDragEnter
        } else {
            // UIControlEventTouchDragInside
        }
    }
}


/*
 //UIControlEventTouchDragOutside
 // 当一次触摸在控件窗口之外拖动时。
 //UIControlEventTouchDragEnter
 // 当一次触摸从控件窗口之外拖动到内部时。
 //UIControlEventTouchDragExit
 
 
 [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
 [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
 [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
 [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
 [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
 
 
 - (void)beginRecordVoice:(UIButton *)button
 {
 [MP3 startRecord];
 playTime = 0;
 playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
 [UUProgressHUD show];
 }
 
 - (void)endRecordVoice:(UIButton *)button
 {
 if (playTimer) {
 [MP3 stopRecord];
 [playTimer invalidate];
 playTimer = nil;
 }
 }
 
 - (void)cancelRecordVoice:(UIButton *)button
 {
 if (playTimer) {
 [MP3 cancelRecord];
 [playTimer invalidate];
 playTimer = nil;
 }
 [UUProgressHUD dismissWithError:@"Cancel"];
 }
 
 - (void)RemindDragExit:(UIButton *)button
 {
 [UUProgressHUD changeSubTitle:@"Release to cancel"];
 }
 
 - (void)RemindDragEnter:(UIButton *)button
 {
 [UUProgressHUD changeSubTitle:@"Slide up to cancel"];
 }
 
 
 - (void)countVoiceTime
 {
 playTime ++;
 if (playTime>=60) {
 [self endRecordVoice:nil];
 }
 }
 */

/**
 *  初始化录音配置
 */
- (void)setupAudio
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz)   8000/44100/96000（音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //    NSString *strUrl = @"/Users/winjay/Desktop";
    YTLog(@"%@",strUrl);
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/lll.aac", strUrl]];
    self.urlPlay = url;
    //初始化
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:nil];
    //开启音量检测
    self.recorder.meteringEnabled = YES;
}

#pragma mark - lazy
- (UIImage *)logoImage
{
    if (!_logoImage) {
        _logoImage = [UIImage imageNamed:@"yunjian"];
    }
    return _logoImage;
}

@end
