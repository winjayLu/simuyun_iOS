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
#import "YTOtherViewController.h"
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

#define magin 3

@interface YTHomeViewController () <TopViewDelegate, ContentViewDelegate, BottomViewDelegate, UIScrollViewDelegate>

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
@property (nonatomic, strong) NSArray *todos;

@property (nonatomic, weak) UIScrollView *mainView;

// h5页面填充token
@property (nonatomic, strong) YTTokenView *token;

// 是否加载用户信息
@property (nonatomic, assign) BOOL isLoad;


@end

@implementation YTHomeViewController


- (void)loadView
{
    // 将控制器的View替换为ScrollView
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:DeviceBounds];
    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.contentSize = CGSizeMake(100, 10000);
    mainView.delegate = self;
    self.view = mainView;
    self.mainView = mainView;
    self.view.backgroundColor = YTViewBackground;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化顶部视图
    [self setupTopView];
    
    // 初始化待办事项
    [self setupTodoView];
    
    // 初始化底部菜单
    [self setupBottom];
    
    // 监听左侧菜单通知
    [self leftMenuNotification];
    
    // 加载待办事项
    [self loadTodos];
    
    // 获取用户信息
    [self loadUserInfo];
   
    // 填充token
    self.token = [[YTTokenView alloc] init];
    
    // 检查更新
    [self updateData];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 判断标志位
    if (self.isLoad) {
        self.isLoad = NO;
        return;
    }
    // 重新加载用户信息
    [YTUserInfoTool loadUserInfoWithresult:^(BOOL result) {
        if (result) {
            [SVProgressHUD dismiss];
            self.topView.userInfo = [YTUserInfoTool userInfo];
        }
    }];
    // 加载待办事项
    [self loadTodos];
}

// 检查更新
- (void)updateData
{
    YTResources *resources = [YTResourcesTool resources];

    NSURL *updateUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/si-mu-yun-san-fang-li-cai/id933795157?mt=8&uo=4"];
    if (resources.version != nil && resources.version.length > 0) { // 有新版本
        if ([resources.isMustUpdate isEqualToString:@"y"]) {
            HHAlertView *alert = [HHAlertView shared];
            [alert showAlertWithStyle:HHAlertStyleDefault imageName:@"gantan" Title:@"发现新版本" detail:resources.adverts cancelButton:nil Okbutton:@"去更新" block:^(HHAlertButton buttonindex) {
                 [[UIApplication sharedApplication] openURL:updateUrl];
            }];
        } else {
            HHAlertView *alert = [HHAlertView shared];
            [alert showAlertWithStyle:HHAlertStyleDefault imageName:@"gantan" Title:@"发现新版本" detail:resources.adverts cancelButton:@"取消" Okbutton:@"去更新" block:^(HHAlertButton buttonindex) {
                if (buttonindex == HHAlertButtonOk) {
                    
                    [[UIApplication sharedApplication] openURL:updateUrl];
                } else {
                    [alert hide];
                }
            }];
        }
    }
}



/**
 *  加载用户信息
 */
- (void)loadUserInfo
{
    // 第一次加载

    if ([YTUserInfoTool userInfo] == nil) {
        [YTUserInfoTool loadUserInfoWithresult:^(BOOL result) {
            if (result) {
                [SVProgressHUD dismiss];
                self.topView.userInfo = [YTUserInfoTool userInfo];
            }
        }];
    } else {
        self.topView.userInfo = [YTUserInfoTool userInfo];
    }
    self.isLoad = YES;
}


#pragma mark - 初始化
/**
 *  初始化顶部视图
 */
- (void)setupTopView
{
    // 顶部视图
    YTProfileTopView *topView = [YTProfileTopView profileTopView];
    topView.frame = CGRectMake(0, 0, self.view.frame.size.width, 270);
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
/**
 *  初始化待办事项
 */
- (void)setupTodoView
{
    // 计算todoView的高度
    
    CGFloat groupCellHeight = 42;
    CGFloat conetentCellHeight = 52;
    CGFloat todoHeight = groupCellHeight + self.todos.count * conetentCellHeight;
    
    YTContentView *content = [[YTContentView alloc] init];
    content.frame = CGRectMake(magin, CGRectGetMaxY(self.topView.frame), self.view.width - magin * 2, todoHeight);
    content.layer.cornerRadius = 5;
    content.layer.masksToBounds = YES;
    content.daili = self;
    [self.view addSubview:content];
    self.todoView = content;
}
/**
 *  初始化底部菜单
 */
- (void)setupBottom
{
    YTBottomView *bottom = [[YTBottomView alloc] init];
    bottom.layer.cornerRadius = 5;
    bottom.layer.masksToBounds = YES;
    bottom.frame = CGRectMake(magin, CGRectGetMaxY(self.todoView.frame) + 8, self.view.width - magin * 2, 42 * 3);
    bottom.BottomDelegate = self;
    [self.view addSubview:bottom];
    self.bottom = bottom;
    // 设置滚动范围
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(bottom.frame) + 64)];
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
//    param[@"adviserId"] = [YTAccountTool account].userId;
            param[@"adviserId"] = @"001e4ef1d3344057a995376d2ee623d4";
    param[@"category"] = @1;
    param[@"pagesize"] = @3;
    param[@"pageNo"] = @(1);
    [YTHttpTool get:YTChatContent params:param success:^(id responseObject) {
        self.todos = [YTMessageModel objectArrayWithKeyValuesArray:responseObject[@"messageList"]];
        [self updateTodos];
    } failure:^(NSError *error) {
    }];
}

// 给todoView设置数据
- (void)updateTodos
{
    // 设置数据
    self.todoView.todos = self.todos;
    
    // 修改todo的frame
    CGFloat groupCellHeight = 42;
    CGFloat conetentCellHeight = 52;
    CGFloat todoHeight = groupCellHeight + self.todos.count * conetentCellHeight;
    self.todoView.frame = CGRectMake(magin, CGRectGetMaxY(self.topView.frame), self.view.width - magin * 2, todoHeight);

    // 修改底部菜单frame
    self.bottom.frame = CGRectMake(magin, CGRectGetMaxY(self.todoView.frame) + 8, self.view.width - magin * 2, 42 * 3);
    
    // 设置滚动范围
    [(UIScrollView *)self.view setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(self.bottom.frame) + 64)];
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
    
    NSString *btnTitle = note.userInfo[YTLeftMenuSelectBtn];
    UIViewController *vc = nil;
    // 判断点击了哪个按钮
    if ([btnTitle isEqualToString:@"用户资料"]) {
        vc = [YTNormalWebController webWithTitle:@"用户资料" url:[NSString stringWithFormat:@"%@/my/profile/", YTH5Server]];
    } else if([btnTitle isEqualToString:@"关联微信"]){
         [self relationWeChat];
    } else if([btnTitle isEqualToString:@"推荐私募云给好友"]){
        vc = [YTNormalWebController webWithTitle:@"测试" url:@"http://www.simuyun.com/product/floating.html"];
    } else if([btnTitle isEqualToString:@"帮助"]){
        vc = [YTNormalWebController webWithTitle:@"帮助" url:@"http://www.simuyun.com/help/"];
    } else if([btnTitle isEqualToString:@"关于私募云"]){
        vc = [YTNormalWebController webWithTitle:@"关于私募云" url:@"http://www.simuyun.com/about/"];
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
    UIViewController *vc = nil;
    if (row == 0) {
        // 获取根控制器
        [YTCenter postNotificationName:YTJumpToTodoList object:nil];
        YTTabBarController *appRootVC = (YTTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [appRootVC setSelectedIndex:0];
    } else {
        vc = [[YTNormalWebController alloc] init];
        ((YTNormalWebController *)vc).url = @"http://www.simuyun.com/message";
        ((YTNormalWebController *)vc).toTitle = @"待办事项";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/**
 *  底部菜单选中
 *
 */
- (void)didSelectedRow:(int)row
{
    YTOrderCenterController *order = [[YTOrderCenterController alloc] init];
    order.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:order animated:YES];
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
        case TopButtonTypeRenzhen:  // 认证
            [self Authentication];
            break;
        case TopButtonTypeQiandao:  // 签到
            [self signIn];
            break;
        case TopButtonTypeYundou:   // 云豆
            [alert showAlertWithTitle:YTYunDouGuiZe detail:YTYunDouGuiZeContent];
            break;
        case TopButtonTypeKehu:     // 客户
            pushVc = [YTNormalWebController webWithTitle:@"我的客户" url:@"http://www.simuyun.com/my/clients/"];
            break;
        case TopButtonTypeDindan:   // 订单
            pushVc = [[YTOrderCenterController alloc] init];
            
            break;
        case TopButtonTypeYeji:     // 业绩
            pushVc = [YTNormalWebController webWithTitle:@"我的业绩" url:@"http://www.simuyun.com/my/performance/"];
            break;
        case TopButtonTypeMenu:
            [self leftClick];
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
}
/**
 *  签到
 *
 */
- (void)signIn
{
    YTBlackAlertView *alert = [YTBlackAlertView shared];
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
        // 资讯id
        NSString *infoId = responseObject[@"infoId"];
        // 弹出提醒
        [alert showAlertSignWithTitle:responseObject[@"infoTitle"] date:responseObject[@"signInDate"] yunDou:responseObject[@"todayPoint"] block:^{
            if (infoId != nil && infoId.length > 0) {
                YTOtherViewController *other = [[YTOtherViewController alloc] init];
                other.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:other animated:YES];
            }
        }];
    } failure:^(NSError *error) {
        
    }];
}
/**
 *  认证
 *
 */
- (void)Authentication
{
    if ([YTUserInfoTool userInfo].phoneNumer != nil && [YTUserInfoTool userInfo].phoneNumer.length > 0) {
        
    }
    
    UIViewController *vc = nil;
    int status = [YTUserInfoTool userInfo].adviserStatus;
    if(status == 1)
    {
        vc = [[YTAuthenticationViewController alloc] init];
    } else if (status == 2)
    {
        vc = [[YTAuthenticationStatusController alloc] init];
    } else if (status == 3)
    {
        vc = [[YTAuthenticationErrorController alloc] init];
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  关联微信
 *
 */
- (void)relationWeChat
{
#warning TODO重新加载用户信息
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
                YTLog(@"%@", responseObject);
            } failure:^(NSError *error) {
                YTLog(@"%@", error);
            }];
        }
    });
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        // 进入到微信
        param[@"sex"] = response.data[@"gender"];
        param[@"address"] = response.data[@"location"];
    }];

}


#pragma mark - 获取数据

#pragma mark - 懒加载
- (NSArray *)todos
{
    if (!_todos) {
        _todos = [[NSArray alloc] init];
    }
    return _todos;
}


- (void)dealloc
{
    [YTCenter removeObserver:self];
}

@end
