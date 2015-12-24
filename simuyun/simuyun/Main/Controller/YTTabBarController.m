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
#import "YTProductGroupController.h"
#import "YTProfileViewController.h"
#import "YTSchoolViewController.h"
#import "YTDiscoverViewController.h"
#import "YTNavigationController.h"
#import "YTLogoView.h"
#import "YTAccountTool.h"
#import "YTRedrainViewController.h"
#import "YTMessageNumTool.h"
#import "CoreArchive.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "NSDictionary+Extension.h"
#import "NSDate+Extension.h"
#import "NSString+Extend.h"


@interface YTTabBarController () <YTLogoViewDelegate>
/**
 *  消息 控制器
 */
@property (nonatomic, strong) YTMessageViewController *message;
/**
 *  产品 控制器
 */
@property (nonatomic, strong) YTProductGroupController *product;
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
 *  tabBar中间的logo按钮
 */
@property (nonatomic, weak) YTLogoView *logo;

/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;

@end



@implementation YTTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子控制器
    [self setupChildVc];

    // 设置tabBar的样式
    [self setupTabBarStyle];
    
    // 选中个人中心控制器
    [self logoViewDidSelectProfileItem];
    
    // 开启定时器时时获取信息
    [self timerOn];
    
    // 获取是否有新消息
    [self loadMessageCount];
    
    [YTCenter addObserver:self selector:@selector(timerOff) name:YTStopRequest object:nil];
}

/**
 *  定时检测
 */
- (void)timingDetection
{
    
    if ([YTAccountTool account].userId == nil || [YTAccountTool account].userId.length == 0) {
        return;
    }
    // 获取是否有新消息
    [self loadMessageCount];
    
    // 获取红包雨
    [self getRedrain];
}


/**
 *  获取红包雨
 */
- (void)getRedrain
{
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    dict[@"uid"] = [YTAccountTool account].userId;
    
    // 1.创建一个请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    // 2.发送一个GET请求
    NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTRedpacket];

    [mgr GET:newUrl parameters:[NSDictionary httpWithDictionary:dict]
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSString *url = responseObject[@"redpage_url"];
         if (url != nil && url.length > 0) {
             YTRedrainViewController *redRain = [[YTRedrainViewController alloc] init];
             redRain.url = url;
             redRain.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
             redRain.modalPresentationStyle = UIModalPresentationOverFullScreen;
             [self presentViewController:redRain animated:NO completion:^{
             }];
             // 停止定时器
             [self timerOff];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if(operation.responseObject[@"message"] != nil)
         {
             if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                 [YTHttpTool tokenError];
             } else {
                 [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
             }
         }
     }];
}

/**
 *  获取是否有新消息
 *
 */
- (void)loadMessageCount
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"adviserId"] = [YTAccountTool account].userId;
    NSString *timestampCategory0 = [CoreArchive strForKey:@"timestampCategory0"];
    NSString *timestampCategory2 = [CoreArchive strForKey:@"timestampCategory2"];
    NSString *timestampCategory3 = [CoreArchive strForKey:@"timestampCategory3"];
    NSString *timestampCategory4 = [CoreArchive strForKey:@"timestampCategory4"];
    if (timestampCategory0 == nil || timestampCategory0.length == 0) {
        timestampCategory0 = @"2013-01-01 00:00:00";
    }
    if (timestampCategory2 == nil || timestampCategory2.length == 0) {
        timestampCategory2 = @"2013-01-01 00:00:00";
    }
    if (timestampCategory3 == nil || timestampCategory3.length == 0) {
        timestampCategory3 = @"2013-01-01 00:00:00";
    }
    // 运营公告
    if (timestampCategory4 == nil || timestampCategory4.length == 0) {
        timestampCategory4 = @"2013-01-01 00:00:00";
    }
    params[@"timestampCategory0"] = timestampCategory0;
    params[@"timestampCategory2"] = timestampCategory2;
    params[@"timestampCategory3"] = timestampCategory3;
    params[@"timestampCategory4"] = timestampCategory4;
    [YTHttpTool get:YTMessageCount params:params success:^(id responseObject) {
        YTMessageNum *oldMessage = [YTMessageNumTool messageNum];
        [YTMessageNumTool save:[YTMessageNum objectWithKeyValues:responseObject]];
        YTMessageNum *newMessageNum = [YTMessageNumTool messageNum];
        if (oldMessage != nil && (newMessageNum.TODO_LIST > oldMessage.TODO_LIST)) {
            [YTCenter postNotificationName:YTUpdateTodoFrame object:nil];
        }
        if (newMessageNum.CHAT_CONTENT > 0) {
            self.message.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", newMessageNum.CHAT_CONTENT];
            [YTCenter postNotificationName:YTUpdateChatContent object:nil];
        }
    } failure:^(NSError *error) {
    }];
}

/*
 *  新开一个定时器
 */
-(void)timerOn{
    
    [self timerOff];
    
    if(self.timer!=nil) return;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(timingDetection) userInfo:nil repeats:YES];
    
    //记录
    self.timer = timer;
    
    //加入主循环
//    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

/*
 *  关闭定时器
 */
-(void)timerOff{
    
    //关闭定时器
    [self.timer invalidate];
    
    //清空属性
    self.timer = nil;
}


/**
 *  初始化子控制器
 */
- (void)setupChildVc
{
    NSDate *activityDate = [@"2015-12-25 00:00:00" stringWithDate:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *today = [NSDate date];
    NSComparisonResult result = [activityDate compare:today];
    if (result <= 0) {
        self.message = (YTMessageViewController *)[self addOneChildVcClass:[YTMessageViewController class] title:@"消息" image:@"christmass" selectedImage:@"christmassanxia"];
        self.product = (YTProductGroupController *)[self addOneChildVcClass:[YTProductGroupController class] title:@"产品" image:@"christmasi" selectedImage:@"christmasianxia"];
        self.profile = (YTProfileViewController *)[self addOneChildVcClass:[YTProfileViewController class] title:nil image:nil selectedImage:nil];
        self.discover = (YTDiscoverViewController *)[self addOneChildVcClass:[YTDiscoverViewController class] title:@"发现" image:@"christmasm" selectedImage:@"christmasmanxia"];
        self.school = (YTSchoolViewController *)[self addOneChildVcClass:[YTSchoolViewController class] title:@"学院" image:@"christmasu" selectedImage:@"christmasuanxia"];
    } else {
        self.message = (YTMessageViewController *)[self addOneChildVcClass:[YTMessageViewController class] title:@"消息" image:@"xiaoxi" selectedImage:@"xiaoxianxia"];
        self.product = (YTProductGroupController *)[self addOneChildVcClass:[YTProductGroupController class] title:@"产品" image:@"chanpin" selectedImage:@"chanpinanxia"];
        self.profile = (YTProfileViewController *)[self addOneChildVcClass:[YTProfileViewController class] title:nil image:nil selectedImage:nil];
        self.discover = (YTDiscoverViewController *)[self addOneChildVcClass:[YTDiscoverViewController class] title:@"发现" image:@"faxian" selectedImage:@"faxiananxia"];
        self.school = (YTSchoolViewController *)[self addOneChildVcClass:[YTSchoolViewController class] title:@"学院" image:@"shangxueyuan" selectedImage:@"shangxueyuananxia"];
    }
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

    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"dibubackgroud"]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


/**
 *  视图即将显示的时候调用
 *
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.logo == nil) {
        // 添加一个logo按钮到tabBar上
        [self setupLogoView];
    }
    // 执行动画
    [self.logo showAnimation];
}

- (void)setupLogoView
{
    YTLogoView *logo = [[YTLogoView alloc] init];
    logo.size = logo.logoImage.size;
    logo.center = CGPointMake(self.tabBar.width * 0.5, self.tabBar.height * 0.5 - 12);
    logo.userInteractionEnabled = YES;
    logo.delegate = self;
    [self.tabBar addSubview:logo];
    self.logo = logo;
}

- (void)logoViewDidSelectProfileItem
{
    [self setSelectedIndex:2];
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
                                            NSForegroundColorAttributeName : YTTabBarSelectedColor
                                            } forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : YTTabBarNormalColor
                                            } forState:UIControlStateNormal];
    
    // 同时设置tabbar每个标签的文字和图片
    if (![vc isKindOfClass:[YTProfileViewController class]]) {  // 忽略个人中心界面
        vc.title = title;
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    // 包装一个导航控制器后,再成为tabbar的子控制器
    
    YTNavigationController *nav = [[YTNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    return vc;
}

- (void)dealloc
{
    [YTCenter removeObserver:self];
}


@end



