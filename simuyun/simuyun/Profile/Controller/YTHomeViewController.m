//
//  YTHomeViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import "YTHomeViewController.h"
#import "YTProfileTopView.h"
#import "UIImage+Extend.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIBarButtonItem+Extension.h"
#import "YTContentView.h"
#import "YTBottomView.h"
#import "YTUserInfoTool.h"
#import "SVProgressHUD.h"
#import "YTOrderCenterController.h"
#import "YTBlackAlertView.h"
#import "YTInformationController.h"
#import "YTTabBarController.h"
#import "YTAccountTool.h"
#import "YTAuthenticationViewController.h"
#import "YTAuthenticationStatusController.h"
#import "YTNormalWebController.h"
#import "YTAuthenticationErrorController.h"
#import "UMSocial.h"
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"
#import "YTAccountTool.h"
#import "YTTokenView.h"
#import "YTMessageModel.h"
#import "YTResourcesTool.h"
#import "HHAlertView.h"
#import "YTBindingPhoneController.h"
#import "NSDate+Extension.h"
#import "ShareCustomView.h"
#import "ShareManage.h"
#import "YTInformationWebViewController.h"
#import "YTJpushTool.h"
#import "TimerLoopView.h"
#import "YTTodoListViewController.h"
#import "YTAboutViewController.h"
#import "YTGroupCell.h"
#import "YTAuthenticationViewController.h"
#import "YTAuthenticationStatusController.h"
#import "YTAuthenticationErrorController.h"
#import "NSString+JsonCategory.h"
#import "NSObject+JsonCategory.h"
#import "CoreArchive.h"
#import "AFNetworking.h"
#import "YTProductdetailController.h"
#import "YTScanView.h"
#import <RongIMKit/RongIMKit.h>
#import "YTLoginViewController.h"
#import "YTNavigationController.h"
#import "YTAuthenCodeView.h"



#define magin 3

@interface YTHomeViewController () <TopViewDelegate, ContentViewDelegate, BottomViewDelegate, UIScrollViewDelegate, shareCustomDelegate, UIWebViewDelegate, loopViewDelegate, RCIMUserInfoDataSource, RCIMConnectionStatusDelegate>

/**
 *  顶部视图
 */
@property (nonatomic, weak) YTProfileTopView *topView;

/**
 *  待办事项
 */
@property (nonatomic, weak) YTContentView *todoView;
/**
 *  底部视图
 */
@property (nonatomic, weak) YTBottomView *bottom;

/**
 *  待办事项数据
 */
@property (nonatomic, strong) NSMutableArray *todos;

@property (nonatomic, weak) UIScrollView *mainView;

// h5页面填充token
@property (nonatomic, strong) YTTokenView *token;


// 分享
@property (nonatomic, weak) ShareCustomView *customView ;

// 签到弹出框
@property (nonatomic, strong) YTBlackAlertView *blackAlert;

// 跑马灯视图
@property (nonatomic, weak) TimerLoopView *loopView;

// 认证提醒
@property (nonatomic, weak) YTGroupCell *groupCell;


@end

@implementation YTHomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YTViewBackground;
    
    [MobClick event:@"nav_click" attributes:@{@"按钮" : @"首页"}];
    
    // 初始化顶部视图
    [self setupTopView];
    // 加载本地用户信息
    self.topView.userInfo = [YTUserInfoTool userInfo];
    
    // 初始化底部ScrollView
    [self setupScrollView];
    
    // 初始化提醒认证视图
    [self setupAuthentication];
    
    // 初始化待办事项
    [self setupTodoView];
    
    // 初始化底部菜单
    [self setupBottom];
    
    // 监听左侧菜单通知
    [self leftMenuNotification];
   
    // 填充token
    self.token = [[YTTokenView alloc] init];
    self.token.delegate = self;
    
    // 获取运营公告跑马灯
    [self loadLoopView];
    
    // 检查更新
    [self updateData];
    
    // 获取首页图片地址
    [self loadImageUrl];
    
    // 登录融云
    [self loginRongCloud];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 加载待办事项
    [self loadTodos];

    [YTCenter postNotificationName:YTUpdateIconImage object:nil];
    
    // 从服务器获取用户信息
    [YTUserInfoTool loadNewUserInfo:^(BOOL finally) {
        if (finally) {
            self.topView.userInfo = [YTUserInfoTool userInfo];
            [YTCenter postNotificationName:YTUpdateIconImage object:nil];
            [self updateAuthentication];
            // 更换待报备订单数量
            [self.bottom reloadData];
        }
    }];
}



// 检查更新
- (void)updateData
{
    YTResources *resources = [YTResourcesTool resources];

    NSURL *updateUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/si-mu-yun-san-fang-li-cai/id933795157?mt=8&uo=4"];
    if (resources.version != nil && resources.version.length > 0) { // 有新版本
        if ([resources.isMustUpdate isEqualToString:@"y"]) {
            HHAlertView *alert = [HHAlertView shared];
            [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:@"发现新版本" detail:resources.adverts cancelButton:nil Okbutton:@"去更新" block:^(HHAlertButton buttonindex) {
                 [[UIApplication sharedApplication] openURL:updateUrl];
            }];
        } else {
            HHAlertView *alert = [HHAlertView shared];
            [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:@"发现新版本" detail:resources.adverts cancelButton:@"取消" Okbutton:@"去更新" block:^(HHAlertButton buttonindex) {
                if (buttonindex == HHAlertButtonOk) {
                    
                    [[UIApplication sharedApplication] openURL:updateUrl];
                }
            }];
        }
    }
}

#pragma mark - 初始化
/**
 *  初始化顶部视图
 */
- (void)setupTopView
{
    // 顶部视图
    YTProfileTopView *topView = [YTProfileTopView profileTopView];
    topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 310);
    topView.delegate = self;
    [topView setIconImageWithImage:nil];
    topView.layer.masksToBounds = YES;
    topView.layer.cornerRadius = self.topView.frame.size.width * 0.5;
    topView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    topView.layer.shouldRasterize = YES;
    topView.clipsToBounds = YES;
    [self.view addSubview:topView];
    self.topView = topView;
}

#pragma mark - 跑马灯
/**
 *  初始化跑马灯视图
 */
- (void)loadLoopView
{
    [YTHttpTool get:YTMarquee params:nil success:^(id responseObject) {
        NSArray *array = [LoopObj objectArrayWithKeyValuesArray:responseObject];
        
        if (array.count > 0) {
            TimerLoopView *loop=[[TimerLoopView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) - 40, DeviceWidth, 40) withitemArray:array];
            loop.height = 0;
            [self.view addSubview:loop];
            loop.loopDelegate = self;
            self.loopView = loop;
            [UIView animateWithDuration:0.5 animations:^{
                loop.height = 40;
                self.mainView.y = CGRectGetMaxY(self.loopView.frame);
            }];
            CGSize oldContent = self.mainView.contentSize;
            self.mainView.contentSize = CGSizeMake(oldContent.width, oldContent.height + 48);
        }
        
    } failure:^(NSError *error) {
    }];
}

// 跑马灯代理方法
- (void)removeVIew
{
//    [self.loopView removeFromSuperview];
//    self.loopView = nil;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.mainView.y = 262;
//    }];
//    CGSize oldContent = self.mainView.contentSize;
//    self.mainView.contentSize = CGSizeMake(oldContent.width, oldContent.height - 48);
}

- (void)pushView:(LoopObj *)loopObj
{
    YTNormalWebController *webVc = [YTNormalWebController webWithTitle:loopObj.title url:[NSString stringWithFormat:@"%@/notice%@&id=%@",YTH5Server, [NSDate stringDate], loopObj.message_id]];
    webVc.hidesBottomBarWhenPushed = YES;
    webVc.isDate = YES;
    [self.navigationController pushViewController:webVc animated:YES];
    [MobClick event:@"main_click" attributes:@{@"按钮" : @"跑马灯", @"机构" : [YTUserInfoTool userInfo].organizationName}];
}

#pragma mark - 底部视图
/**
 *  初始化底部ScrollView
 */
- (void)setupScrollView
{
    // 底部视图为Scrollview
    CGFloat scrollViewY = CGRectGetMaxY(self.loopView.frame);
    
    if (scrollViewY == 0) {
        scrollViewY = 262;
    }
    CGFloat scrollViewH = DeviceHight - scrollViewY;
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, DeviceWidth, scrollViewH)];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.contentSize = CGSizeMake(DeviceWidth, scrollViewH);
    mainView.delegate = self;
//    mainView.bounces = NO;
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    self.mainView = mainView;
}


/**
 *  初始化提醒认证视图
 */
- (void)setupAuthentication
{
    YTGroupCell *groupCell = [[[NSBundle mainBundle] loadNibNamed:@"YTGroupCell" owner:nil options:nil] lastObject];
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    groupCell.title = @"认证理财师";
    CGFloat groupCellHeight = 42;
    CGFloat groupCellY = 8;
    switch (userInfo.adviserStatus) {
        case 0:
            groupCell = 0;
            groupCellY = 8;
            break;
        case 1:
            self.groupCell.detailTitle = @"";
            groupCell.pushVc = [YTAuthenticationViewController class];
            if (userInfo.phoneNumer == nil || userInfo.phoneNumer.length == 0) {
                groupCell.pushVc = [YTBindingPhoneController class];
            }
            break;
        case 2:
            groupCell.detailTitle = @"（审核中）";
            groupCell.pushVc = [YTAuthenticationStatusController class];
            break;
        case 3:
            groupCell.detailTitle = @"（未成功）";
            groupCell.pushVc = [YTAuthenticationErrorController class];
            break;
    }
    groupCell.isShowLine = NO;
    groupCell.layer.cornerRadius = 5;
    groupCell.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(todoTitleClick)];
    [groupCell addGestureRecognizer:tap];
    // 计算groupCell的高度
    groupCell.frame = CGRectMake(magin, groupCellY, self.view.width - magin * 2, groupCellHeight);
    
    [self.mainView addSubview:groupCell];
    self.groupCell = groupCell;
}
/**
 *  更新认证状态
 */
- (void)updateAuthentication
{
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    self.groupCell.title = @"认证理财师";
    // 0 已认证， 1 未认证， 2 认证中， 3 驳回
    switch (userInfo.adviserStatus) {
        case 0:
            self.groupCell.height = 0;
            self.groupCell.y = 0;
            [self updateTodos];
            return;
        case 1:
            self.groupCell.detailTitle = @"";
            self.groupCell.pushVc = [YTAuthenticationViewController class];
            self.groupCell.height = 42;
            self.groupCell.y = 8;
            if (userInfo.phoneNumer == nil || userInfo.phoneNumer.length == 0) {
                self.groupCell.pushVc = [YTBindingPhoneController class];
            }
            break;
        case 2:
            self.groupCell.detailTitle = @"（审核中）";
            self.groupCell.pushVc = [YTAuthenticationStatusController class];
            self.groupCell.height = 42;
            self.groupCell.y = 8;
            break;
        case 3:
            self.groupCell.detailTitle = @"（未成功）";
            self.groupCell.pushVc = [YTAuthenticationErrorController class];
            self.groupCell.height = 42;
            self.groupCell.y = 8;
            break;
    }
    [self updateTodos];

}


- (void)todoTitleClick
{
    UIViewController *vc = [[self.groupCell.pushVc alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}




/**
 *  初始化待办事项
 */
- (void)setupTodoView
{
    // 计算todoView的高度
    
    CGFloat groupCellHeight = 42;
    CGFloat conetentCellHeight = 52;
    CGFloat todoHeight = 0;
    if (self.todos.count > 3) {
        todoHeight = groupCellHeight + 3 * conetentCellHeight;
    } else {
        todoHeight = groupCellHeight + self.todos.count * conetentCellHeight;
    }
    YTContentView *content = [[YTContentView alloc] init];
    content.frame = CGRectMake(magin, 8, self.view.width - magin * 2, todoHeight);
    content.todos = self.todos;
    if (self.groupCell != nil) {
        content.frame = CGRectMake(magin, CGRectGetMaxY(self.groupCell.frame) + 8, self.view.width - magin * 2, todoHeight);
    }
    content.layer.cornerRadius = 5;
    content.layer.masksToBounds = YES;
    content.daili = self;
    [self.mainView addSubview:content];
    self.todoView = content;
    [YTCenter addObserver:self selector:@selector(updateTodoFrame) name:YTUpdateTodoFrame object:nil];
    [YTCenter addObserver:self selector:@selector(loadTodos) name:YTUpdateTodoData object:nil];
}


/**
 *  初始化底部菜单
 */
- (void)setupBottom
{
    YTBottomView *bottom = [[YTBottomView alloc] initWithFrame:CGRectMake(magin, CGRectGetMaxY(self.todoView.frame) + 8, self.view.width - magin * 2, 42 * 3)];
    bottom.layer.cornerRadius = 5;
    bottom.layer.masksToBounds = YES;
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    if([YTResourcesTool isVersionFlag] == NO)
    {
        bottom.height = 42;
    } else if (userInfo.teamNum == 0)
    {
        bottom.height = 84;
    }
    bottom.BottomDelegate = self;
    [self.mainView addSubview:bottom];
    self.bottom = bottom;
    // 设置滚动范围
    [self.mainView setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(bottom.frame) + 64)];
    [self.bottom reloadData];
}

#pragma makr - 监听通知
/**
 *  监听左侧菜单通知
 */
- (void)leftMenuNotification
{
    [YTCenter addObserver:self selector:@selector(leftMenuClick:) name:YTLeftMenuNotification object:nil];
    
    // 监听通知
    [YTCenter addObserver:self selector:@selector(updateUserInfo) name:YTUpdateUserInfo object:nil];
}


#pragma mark - 加载数据
// 加载新数据
- (void)loadTodos
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"category"] = @1;
    param[@"pagesize"] = @20;
    param[@"pageNo"] = @(1);
    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        NSMutableArray *array = [YTMessageModel objectArrayWithKeyValuesArray:responseObject[@"messageList"]];
        if (array.count > 0) {
            self.todos = array;
            [self updateTodos];
            NSString *oldHomeTodo = [responseObject JsonToString];
            [CoreArchive setStr:oldHomeTodo key:@"oldHomeTodo"];
        } else
        {
            [CoreArchive setStr:nil key:@"oldHomeTodo"];
        }
    } failure:^(NSError *error) {
    }];
}

// 给todoView设置数据
- (void)updateTodos
{
    // 设置数据
    self.todoView.todos = self.todos;
    // 更新frame
    [self updateTodoFrame];

}
// 修改todoView的frame
- (void)updateTodoFrame
{
    // 修改todo的frame
    CGFloat groupCellHeight = 42;
    CGFloat conetentCellHeight = 52;
    CGFloat todoHeight = 0;
    if (self.todos.count > 3) {
        todoHeight = groupCellHeight + 3 * conetentCellHeight;
    } else {
        todoHeight = groupCellHeight + self.todos.count * conetentCellHeight;
    }

    self.todoView.frame = CGRectMake(magin, CGRectGetMaxY(self.groupCell.frame) + 8, self.view.width - magin * 2, todoHeight);

    // 修改底部菜单frame
    self.bottom.y = CGRectGetMaxY(self.todoView.frame) + 8;
    if([YTResourcesTool isVersionFlag] == YES && [YTUserInfoTool userInfo].teamNum > 0)
    {
        self.bottom.height = 126;
    } else if([YTResourcesTool isVersionFlag] == YES && [YTUserInfoTool userInfo].teamNum == 0){
        self.bottom.height = 84;
    }
    
    // 设置滚动范围
    [self.mainView setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(self.bottom.frame) + 64)];
    if (self.loopView != nil) {
        CGSize oldContent = self.mainView.contentSize;
        self.mainView.contentSize = CGSizeMake(oldContent.width, oldContent.height + 48);
    }
    
    // 修改提醒数字
    [self.todoView setTodoNum];
}

#pragma mark - 响应事件
/**
 *  左侧菜单选中事件
 *
 */
- (void)leftMenuClick:(NSNotification *)note
{
    // 调用代理方法
    [self.delegate leftMenuClicked];
    
    NSString *btnTitle = nil;
    if (note != nil) {
        btnTitle = note.userInfo[YTLeftMenuSelectBtn];
    }
    UIViewController *vc = nil;
    
    
    // 判断点击了哪个按钮
    if ([btnTitle isEqualToString:@"用户资料"]) {
        vc = [YTNormalWebController webWithTitle:@"用户资料" url:[NSString stringWithFormat:@"%@/my/profile/", YTH5Server]];
        ((YTNormalWebController *)vc).isProgress = YES;
    } else if([btnTitle isEqualToString:@"关联微信"] || [btnTitle isEqualToString:@"已关联微信"]){
         [self relationWeChat];
    } else if([btnTitle isEqualToString:@"推荐私募云给好友"]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self shareClcik];
        });
    } else if([btnTitle isEqualToString:@"帮助"]){
        //
        vc = [YTNormalWebController webWithTitle:@"帮助" url:[NSString stringWithFormat:@"%@/help/", YTH5Server]];
    } else if([btnTitle isEqualToString:@"关于私募云"]){
        vc = [[YTAboutViewController alloc] init];
    } else if([btnTitle isEqualToString:@"400-188-8848"]){
        UIWebView *callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:@"tel://400-188-8848"];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }
    
    // 跳转对应控制器
    if (vc != nil) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
}
/**
 *  待办事项选中事件
 *
 */
- (void)selectedTodo:(NSUInteger)row
{
    if (row == -1) {
        YTTodoListViewController *todoVc = [[YTTodoListViewController alloc] init];
        todoVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:todoVc animated:YES];
        
        [MobClick event:@"main_click" attributes:@{@"按钮" : @"全部待办", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    } else {
        YTMessageModel *message = self.todos[row];
        if (message.messageId.length == 0) {
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
            
           UIViewController *rootVc =  keyWindow.rootViewController;
            if ([rootVc isKindOfClass:[YTTabBarController class]]) {
                ((YTTabBarController *)rootVc).selectedIndex = 1;
            }
            return;
        }
        
        YTNormalWebController *vc = [YTNormalWebController webWithTitle:@"待办事项" url:[NSString stringWithFormat:@"%@/notice%@&id=%@",YTH5Server, [NSDate stringDate], message.messageId]];
        vc.isDate = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [MobClick event:@"main_click" attributes:@{@"按钮" : @"单个待办", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    }
}
/**
 *  底部菜单选中
 *
 */
- (void)didSelectedName:(NSString *)name
{
    UIViewController *vc = nil;
    if ([name isEqualToString:@"我的团队"]) {
        vc = [YTNormalWebController webWithTitle:@"我的团队" url:[NSString stringWithFormat:@"%@/my/team%@", YTH5Server,[NSDate stringDate]]];
        [MobClick event:@"main_click" attributes:@{@"按钮" : @"我的团队", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    } else if([name isEqualToString:@"全部订单"])
    {
        vc = [[YTOrderCenterController alloc] init];
        [MobClick event:@"main_click" attributes:@{@"按钮" : @"全部订单", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    } else if([name isEqualToString:@"云豆银行"])
    {
        vc = [YTNormalWebController webWithTitle:@"云豆银行" url:[NSString stringWithFormat:@"%@/mall%@", YTH5Server,[NSDate stringDate]]];
        [MobClick event:@"main_click" attributes:@{@"按钮" : @"云豆银行", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    }
    if (vc != nil) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


/**
 *  导航栏左侧按钮的点击事件
 */
- (void)leftClick
{
    [self.delegate leftBtnClicked];
}



#pragma mark - 顶部视图代理方法
/**
 *  切换头像
 *
 */
-(void)addPicker:(UIImagePickerController *)picker{
     [MobClick event:@"main_click" attributes:@{@"按钮" : @"更换头像", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    [self presentViewController:picker animated:YES completion:nil];
}
/**
 *  按钮点击事件
 *
 *  @param type 按钮类型
 */
- (void)topBtnClicked:(TopButtonType)type
{
    UIViewController *pushVc = nil;
    YTBlackAlertView *alert = [YTBlackAlertView shared];
    switch (type) {
        case TopButtonTypeQiandao:  // 签到
            [self signIn];
            break;
        case TopButtonTypeYundou:   // 云豆
            [alert showAlertWithTitle:YTYunDouGuiZe detail:YTYunDouGuiZeContent];
            break;
        case TopButtonTypeKehu:     // 客户
            pushVc = [YTNormalWebController webWithTitle:@"我的客户" url:[NSString stringWithFormat:@"%@/my/clients/",YTH5Server]];
            break;
        case TopButtonTypeDindan:   // 订单
            pushVc = [[YTOrderCenterController alloc] init];
            ((YTOrderCenterController *)pushVc).status = @"[80]";
            ((YTOrderCenterController *)pushVc).isYiQueRen = YES;
            break;
        case TopButtonTypeYeji:     // 业绩
            pushVc = [YTNormalWebController webWithTitle:@"我的业绩" url:[NSString stringWithFormat:@"%@/my/performance/",YTH5Server]];
            break;
        case TopButtonTypeMenu:
            [self leftClick];
            break;
        case TopButtonTypeMyScan:
            [self showScanView];
            break;
        case TopButtonTypeAuthen:
            [self showAuthenCodeView];
            break;
    }
    // 跳转对应控制器
    if (pushVc != nil) {
        pushVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushVc animated:YES];
    }
}
// 修改用户信息
- (void)updateUserInfo
{
     self.topView.userInfo = [YTUserInfoTool userInfo];
    [self viewWillAppear:YES];
}
/**
 *  签到
 *
 */
- (void)signIn
{
    if ([YTUserInfoTool userInfo].isSingIn == 1) {
        [SVProgressHUD showInfoWithStatus:@"今日已签到"];
        return;
    }
    
    if(self.blackAlert != nil) return;
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"adviserId"] = [YTAccountTool account].userId;
    [YTHttpTool post:YTSignIn params:params success:^(id responseObject) {
        // 修改数据
        YTUserInfo *userInfo = [YTUserInfoTool userInfo];
        userInfo.isSingIn = 1;
        NSString *totalPoint = responseObject[@"totalPoint"];
        userInfo.myPoint = [totalPoint intValue];
        [YTUserInfoTool saveUserInfo:userInfo];
        self.topView.userInfo = userInfo;
        // 资讯模型
        YTInformation *iformation = [YTInformation objectWithKeyValues:responseObject[@"information"]];
        // 弹出提醒
        if (iformation != nil && iformation.infoId.length > 0) {
            YTBlackAlertView *alert = [YTBlackAlertView shared];
            self.blackAlert = alert;
            [alert showAlertSignWithTitle:iformation.title date:responseObject[@"signInDate"] yunDou:responseObject[@"todayPoint"] block:^{
                YTInformationWebViewController *normal = [YTInformationWebViewController webWithTitle:@"早知道" url:[NSString stringWithFormat:@"%@/information%@&id=%@",YTH5Server, [NSDate stringDate], iformation.infoId]];
                normal.isDate = YES;
                normal.hidesBottomBarWhenPushed = YES;
                normal.information = iformation;
                [self.navigationController pushViewController:normal animated:YES];
                [MobClick event:@"main_click" attributes:@{@"按钮" : @"签到早知道", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            }];
        }
    } failure:^(NSError *error) {
        self.blackAlert = nil;
    }];
}

/**
 *  展示二维码
 */
- (void)showScanView
{
    YTScanView *scanView = [YTScanView shared];
    [scanView showScan];
}

/**
 *  展示认证口令
 */
- (void)showAuthenCodeView
{
    YTAuthenCodeView *anthenCodeView = [YTAuthenCodeView shared];
    anthenCodeView.content = [YTUserInfoTool userInfo].inviteCode;
    [anthenCodeView showScanWithVc:self];
}


#pragma mark - 关联微信
/**
 *  关联微信
 *
 */
- (void)relationWeChat
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //  友盟微信登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *account = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            param[@"advisersId"] = [YTAccountTool account].userId;
            param[@"nickname"] = account.userName;
            param[@"unionid"] = account.unionId;
            param[@"openid"] = account.openId;
            param[@"headimgurl"] = account.iconURL;
            [YTHttpTool post:YTBindWeChat params:param success:^(id responseObject) {
                // 重新加载用户信息
                [YTUserInfoTool loadNewUserInfo:^(BOOL finally) {
                    if (finally) {
                        self.topView.userInfo = [YTUserInfoTool userInfo];
                        [YTCenter postNotificationName:YTUpdateIconImage object:nil];
                        [self updateAuthentication];
                    }
                }];
            } failure:^(NSError *error) {

            }];
        }
    });
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        // 进入到微信
        param[@"sex"] = response.data[@"gender"];
        param[@"address"] = response.data[@"location"];
    }];

}
#pragma mark - 分享
// 分享
- (void)shareClcik
{
    
    if (self.customView != nil) return;
    
    //  设置分享视图平台数据
    NSArray *titleArr = [NSArray arrayWithObjects:@"微信好友",@"朋友圈", nil];
    NSArray *imgArr = [NSArray arrayWithObjects:@"ShareButtonTypeWxShare",@"ShareButtonTypeWxPyq", nil];
    //  创建自定义分享视图
    ShareCustomView *customView = [[ShareCustomView alloc] initWithTitleArray:titleArr imageArray:imgArr isHeight:YES];
    customView.frame = self.view.bounds;
    //  设置代理
    customView.shareDelegate = self;
    [self.view addSubview:customView];
    self.customView = customView;
}
/**
 *  自定义分享视图代理方法
 *
 */
- (void)shareBtnClickWithIndex:(NSUInteger)tag
{
    // 移除分享菜单
    [self.customView cancelMenu];
    self.customView = nil;
    if (tag == ShareButtonTypeCancel) return;
    //  分享工具类
    ShareManage *share = [ShareManage shareManage];
    //  设置分享内容
    [share shareConfig];
    share.share_title = @"私募云：理财师的移动执业工具";
    share.share_content = @"推荐理财师好友安装私募云，一起来聚合财富管理力量！";
    share.share_url = @"http://www.simuyun.com/invite/invite.html";
    share.share_image = [UIImage imageNamed:@"fenxiangpic.jpg"];
    switch (tag) {
        case ShareButtonTypeWxShare:
            //  微信分享
            [share wxShareWithViewControll:self];
            break;
        case ShareButtonTypeWxPyq:
            //  朋友圈分享
             share.share_title = @"推荐理财师好友安装私募云，一起来聚合财富管理力量！";
            [share wxpyqShareWithViewControll:self];
            break;
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *urlString = [[request URL] absoluteString];
    NSArray *result = [urlString componentsSeparatedByString:@":"];
    NSMutableArray *urlComps = [[NSMutableArray alloc] init];
    for (NSString *str in result) {
        [urlComps addObject:[str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if([urlComps count] && [[urlComps objectAtIndex:0] isEqualToString:@"app"])
    {
        // 跳转的地址和标题
        if (urlComps.count) {
            NSString *command = urlComps[1];
            if ([command isEqualToString:@"closepage"])
            {
                [self.token removeFromSuperview];
                self.token = nil;
                [self pushNotificationWithJump];
            }
        }
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 执行js代码
    // userid
    // token
    // version
    NSString *js = [NSString stringWithFormat:@"setData('%@', '%@', '4.100');",[YTAccountTool account].token, [YTAccountTool account].userId];
    [webView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark - 获取首页图片地址
- (void)loadImageUrl
{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.发送一个GET请求
    [mgr GET:@"http://www.simuyun.com/peyunupload/label/homeImageUrl.json" parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSArray *array = [NSString objectArrayWithKeyValuesArray:responseObject];
         // 存储获取到的数据
         [CoreArchive setStr:array[0] key:@"home2x"];
         [CoreArchive setStr:array[1] key:@"home3x"];
         [CoreArchive setStr:array[2] key:@"left2x"];
         [CoreArchive setStr:array[3] key:@"left3x"];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@", error);
     }];
    
}
#pragma mark - 推送跳转
- (void)pushNotificationWithJump
{
    YTJpushModel *jpush = [YTJpushTool jpush];
    if(jpush != nil &&jpush.jumpUrl.length > 0)  // 极光推送
    {
        if (jpush.type == 4) // 产品发行
        {
            [self jumpToProduct:jpush];
        } else {
            [self jumpToNormalWeb:jpush];
        }
    }
}
/**
 *  跳转普通网页
 *
 */
- (void)jumpToNormalWeb:(YTJpushModel *)jpush
{
    YTNormalWebController *webView =[YTNormalWebController webWithTitle:jpush.title url:[NSString stringWithFormat:@"%@%@",YTH5Server, jpush.jumpUrl]];;
    webView.isDate = YES;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:NO];
    [YTJpushTool saveJpush:nil];
}
/**
 *  跳转产品页
 *
 */
- (void)jumpToProduct:(YTJpushModel *)jpush
{
    YTProductdetailController *web = [[YTProductdetailController alloc] init];
    web.url = [NSString stringWithFormat:@"%@%@", YTH5Server, jpush.jumpUrl];
    // 获取产品id
    NSRange range = [jpush.jumpUrl rangeOfString:@"id="];
    web.proId = [jpush.jumpUrl substringFromIndex:range.location + range.length];
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:NO];
    [YTJpushTool saveJpush:nil];
}

/**
 *  登录融云
 */
- (void)loginRongCloud
{
    [[RCIM sharedRCIM] connectWithToken:[CoreArchive strForKey:@"rcToken"] success:^(NSString *userId) {
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 更新未读消息数量
            [YTCenter postNotificationName:YTUpdateUnreadCount object:nil];
            // 跳转消息控制器
            // 检测是否有推送消息
            YTJpushModel *jpush = [YTJpushTool jpush];
            if (jpush != nil && jpush.cType.length > 0) { // 消息推送
                
                [YTCenter postNotificationName:YTSelectedMessageVc object:nil];
                [YTJpushTool saveJpush:nil];
            }
            [RCIM sharedRCIM].connectionStatusDelegate = self;
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"登陆的错误码为:%zd", status);
    } tokenIncorrect:^{
        [self loadToken];
    }];
}

/*!
 IMKit连接状态的的监听器
 
 @param status  SDK与融云服务器的连接状态
 
 @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status
{
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        [self logOut];
    }
}



/*!
 获取用户信息
 
 @param userId      用户ID
 @param completion  获取用户信息完成之后需要执行的Block [userInfo:该用户ID对应的用户信息]
 
 @discussion SDK通过此方法获取用户信息并显示，请在completion中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = userId;
    [YTHttpTool get:YTRcUserInfo params:param success:^(id responseObject) {
        RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userId name:responseObject[@"name"] portrait:responseObject[@"portraitUri"]];
        return completion(userInfo);
    } failure:^(NSError *error) {
        
        return completion(nil);
    }];
}

- (void)loadToken{
    // 获取融云Token
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"uid"] = [YTAccountTool account].userId;
    param[@"tokenExpired"] = @"1";
    [YTHttpTool get:YTToken params:param success:^(id responseObject) {
        [CoreArchive setStr:responseObject[@"rcToken"] key:@"rcToken"];
        [self loginRongCloud];
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  异地登录,强制下线
 */
- (void)logOut
{
    
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:YTTokenError detail:YTTokenErrorContent cancelButton:nil Okbutton:@"知道了" block:^(HHAlertButton buttonindex) {
        // 发送通知
        [YTCenter postNotificationName:YTLogOut object:nil];
    }];
}


#pragma mark - 懒加载
- (NSMutableArray *)todos
{
    if (!_todos) {
        // 获取历史数据
        NSString *oldHomeTodo = [CoreArchive strForKey:@"oldHomeTodo"];
        if (oldHomeTodo != nil) {
            _todos = [YTMessageModel objectArrayWithKeyValuesArray:[oldHomeTodo JsonToValue][@"messageList"]];
            if (_todos.count == 0) {
                YTMessageModel *message = [[YTMessageModel alloc] init];
                message.summary = @"您还没有待办事项，快去认购产品吧！";
                [_todos addObject:message];
            }
            [self updateTodos];
        } else {
            _todos = [[NSMutableArray alloc] init];
            YTMessageModel *message = [[YTMessageModel alloc] init];
            message.summary = @"您还没有待办事项，快去认购产品吧！";
            [_todos addObject:message];
        }
    }
    return _todos;
}

- (void)dealloc
{
    [YTCenter removeObserver:self];
}

@end
