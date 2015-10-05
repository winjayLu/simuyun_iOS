//
//  YTTabBarController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  主控制器

#import "YTTabBarController.h"
#import "YTMessageViewController.h"
#import "YTProductViewController.h"
#import "YTProfileViewController.h"
#import "YTSchoolViewController.h"
#import "YTDiscoverViewController.h"
#import "UIView+Extension.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "YTNavigationController.h"
#import "MBProgressHUD+WJ.h"


@interface YTTabBarController ()
/**
 *  消息 控制器
 */
@property (nonatomic, strong) YTMessageViewController *message;
/**
 *  产品 控制器
 */
@property (nonatomic, strong) YTProductViewController *product;
/**
 *  我 控制器
 */
@property (nonatomic, strong) YTProfileViewController *profile;
/**
 *  学院 控制器
 */
@property (nonatomic, strong) YTSchoolViewController *school;
/**
 *  发现 控制器
 */
@property (nonatomic, strong) YTDiscoverViewController *discover;
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

@end



@implementation YTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildVc];

    
    // 设置tabBar的样式
    [self setupTabBarStyle];
    
    // 初始化录音配置
    [self setupAudio];

}




/**
 *  初始化子控制器
 */
- (void)setupChildVc
{
    self.message = [self addOneChildVcClass:[YTMessageViewController class] title:@"消息" image:@"" selectedImage:@""];
    self.product = [self addOneChildVcClass:[YTProductViewController class] title:@"产品" image:@"" selectedImage:@""];
    self.profile = [self addOneChildVcClass:[YTProfileViewController class] title:nil image:nil selectedImage:nil];
    self.discover = [self addOneChildVcClass:[YTDiscoverViewController class] title:@"发现" image:@"" selectedImage:@""];
    self.school = [self addOneChildVcClass:[YTSchoolViewController class] title:@"学院" image:@"" selectedImage:@""];
}

/**
 *  初始化tabBar的样式
 */
- (void)setupTabBarStyle
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
#warning 设置tabBar的背景颜色,或图片
    self.tabBar.backgroundColor = [UIColor grayColor];
}



/**
 *  视图即将显示的时候调用
 *
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 添加一个logo按钮到tabBar上
    [self setupLogoBtn];
}

/**
 *  初始化logo按钮
 */
- (void)setupLogoBtn
{
    UIButton *logoButton = [[UIButton alloc] init];
    //    self.logoButton.size = self.logoButton.currentBackgroundImage.size;
    logoButton.size = CGSizeMake(100, 100);
    logoButton.center = CGPointMake(self.tabBar.width * 0.5, self.tabBar.height * 0.5);
    [logoButton setBackgroundImage:[UIImage imageNamed:@"11"] forState:UIControlStateNormal];
    [logoButton setBackgroundImage:[UIImage imageNamed:@"11"] forState:UIControlStateHighlighted];
    [logoButton addTarget:self action:@selector(logoClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:logoButton];
    // 添加logo按钮的长按事件
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    longPress.minimumPressDuration = 1; //定义按的时间
    [logoButton addGestureRecognizer:longPress];
}

/**
 *  logo按钮的长按事件
 */
- (void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //7.0第一次运行会提示，是否允许使用麦克风
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    //AVAudioSessionCategoryPlayAndRecord用于录音和播放
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        // 开始录音
        if(self.isTape) return;// 正在录音
        YTLog(@"开始录音");
        self.isTape = YES;
        //创建录音文件，准备录音
        if ([self.recorder prepareToRecord]) {
            //开始
            [self.recorder record];
        }
        [MBProgressHUD showAudio];
        //设置定时检测
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
        
    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
                YTLog(@"结束录音");
        // 结束录音
        self.isTape = NO;
        double cTime = self.recorder.currentTime;
        [MBProgressHUD hidAudio];
        if (cTime > 2) {//如果录制时间<2 不发送
            NSLog(@"发出去");
            [SVProgressHUD showSuccessWithStatus:@"消息已发出"];
            // 读取二进制音频文件
//            NSData *audio = [NSData dataWithContentsOfURL:self.urlPlay];
        }else {
            //删除记录的文件
            [self.recorder deleteRecording];
            //删除存储的
            [SVProgressHUD showErrorWithStatus:@"说话时间太短"];
        }
#warning 测试
        [self.recorder stop];
        [self.timer invalidate];
    }
    
}

/**
 *  logo按钮的单击事件
 */
- (void)logoClick
{
    // 切换到个人中心界面
    [self setSelectedIndex:2];
}


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
    
    NSError *error;
    //初始化
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    YTLog(@"%@",error);
    //开启音量检测
    self.recorder.meteringEnabled = YES;
}

/**
 *  根据分贝 切换对应图片
 */
- (void)detectionVoice
{
    [self.recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [MBProgressHUD setImageName:@"record_animate_01.png"];
//        [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
                [MBProgressHUD setImageName:@"record_animate_02.png"];

    }else if (0.13<lowPassResults<=0.20) {
                [MBProgressHUD setImageName:@"record_animate_03.png"];

    }else if (0.20<lowPassResults<=0.27) {
                [MBProgressHUD setImageName:@"record_animate_04.png"];

    }else if (0.27<lowPassResults<=0.34) {
                [MBProgressHUD setImageName:@"record_animate_05.png"];

    }else if (0.34<lowPassResults<=0.41) {
                [MBProgressHUD setImageName:@"record_animate_06.png"];

    }else if (0.41<lowPassResults<=0.48) {
                [MBProgressHUD setImageName:@"record_animate_07.png"];

    }else if (0.48<lowPassResults<=0.55) {
                [MBProgressHUD setImageName:@"record_animate_08.png"];

    }else if (0.55<lowPassResults<=0.62) {
                [MBProgressHUD setImageName:@"record_animate_09.png"];

    }else if (0.62<lowPassResults<=0.69) {
                [MBProgressHUD setImageName:@"record_animate_10.png"];

    }else if (0.69<lowPassResults<=0.76) {
                [MBProgressHUD setImageName:@"record_animate_11.png"];

    }else if (0.76<lowPassResults<=0.83) {
                [MBProgressHUD setImageName:@"record_animate_12.png"];

    }else if (0.83<lowPassResults<=0.9) {
                [MBProgressHUD setImageName:@"record_animate_13.png"];
    }else {
                [MBProgressHUD setImageName:@"record_animate_14.png"];
    }
}


/**
 * 添加一个子控制器
 * @param vcClass : 子控制器的类名
 * @param title : 标题
 * @param image : 图片
 * @param selectedImage : 选中的图片
 */
- (UIViewController *)addOneChildVcClass:(Class)vcClass title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    UIViewController *vc = [[vcClass alloc] init];

    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor whiteColor]
                                            } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor redColor]
                                            } forState:UIControlStateNormal];
    
    // 同时设置tabbar每个标签的文字和图片
    if (![vc isKindOfClass:[YTProfileViewController class]]) {  // 忽略个人中心界面
        vc.title = title;
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
        // 包装一个导航控制器后,再成为tabbar的子控制器
        
        YTNavigationController *nav = [[YTNavigationController alloc] initWithRootViewController:vc];
        [self addChildViewController:nav];
    } else {
        [self addChildViewController:vc];
    }
    
    return vc;
}


@end



