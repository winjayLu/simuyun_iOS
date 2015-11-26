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

#define magin 3

@interface YTHomeViewController () <TopViewDelegate, ContentViewDelegate, BottomViewDelegate, UIScrollViewDelegate, shareCustomDelegate>

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

// 是否重新加载用户信息
@property (nonatomic, assign) BOOL isLoad;

// 分享
@property (nonatomic, weak) ShareCustomView *customView ;

// 签到弹出框
@property (nonatomic, strong) YTBlackAlertView *blackAlert;


@end

@implementation YTHomeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YTViewBackground;
    
    [MobClick event:@"nav_click" attributes:@{@"按钮" : @"首页"}];
    
    // 初始化顶部视图
    [self setupTopView];
    
    // 初始化底部ScrollView
    [self setupScrollView];
    
    // 初始化待办事项
    [self setupTodoView];
    
    // 初始化底部菜单
    [self setupBottom];
    
    // 监听左侧菜单通知
    [self leftMenuNotification];
   
    // 填充token
    self.token = [[YTTokenView alloc] init];
    
    // 检查更新
    [self updateData];
    
    // 加载用户信息
    [self loadUserInfo];
    
    
    // 检测是否有推送消息
    
//    YTJpushModel *jpush = [YTJpushTool jpush];
    
//    if (jpush != nil) {
//        YTNormalWebController *webVc = [YTNormalWebController webWithTitle:jpush.title url:jpush.jumpUrl];
//        webVc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:webVc animated:YES];
//    }
    NSDictionary *dict = [YTJpushTool test];
    if (dict) {        
        HHAlertView *alert = [HHAlertView shared];
        [alert showAlertWithStyle:HHAlertStyleDefault imageName:@"" Title:@"推送消息" detail:dict.description cancelButton:@"呵呵" Okbutton:@"哈哈" block:^(HHAlertButton buttonindex) {
        }];
    }
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.isLoad == NO)
    {
        self.isLoad = YES;
    } else {    // 重新加载用户信息
        [YTUserInfoTool loadNewUserInfo:^(BOOL result) {
            self.topView.userInfo = [YTUserInfoTool userInfo];
        }];
    }
    
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
                self.topView.userInfo = [YTUserInfoTool userInfo];
            }
        }];
    } else {
        self.topView.userInfo = [YTUserInfoTool userInfo];
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
 *  初始化底部ScrollView
 */
- (void)setupScrollView
{
    // 底部视图为Scrollview
    CGFloat scrollViewY = CGRectGetMaxY(self.topView.frame);
    CGFloat scrollViewH = DeviceHight - scrollViewY;
    UIScrollView *mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewY, DeviceWidth, scrollViewH)];
    mainView.bounces = NO;
    mainView.showsVerticalScrollIndicator = NO;
    mainView.contentSize = CGSizeMake(DeviceWidth, scrollViewH);
    mainView.delegate = self;
    mainView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainView];
    self.mainView = mainView;
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
    content.frame = CGRectMake(magin, 0, self.view.width - magin * 2, todoHeight);
    content.layer.cornerRadius = 5;
    content.layer.masksToBounds = YES;
    content.daili = self;
    [self.mainView addSubview:content];
    self.todoView = content;
    [YTCenter addObserver:self selector:@selector(loadTodos) name:YTUpdateTodoList object:nil];
    [YTCenter addObserver:self selector:@selector(updateTodos) name:YTUpdateTodoFrame object:nil];
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

    if([YTResourcesTool resources].versionFlag == 0)
    {
        bottom.height = 42;
    }
    bottom.BottomDelegate = self;
    [self.mainView addSubview:bottom];
    self.bottom = bottom;
    // 设置滚动范围
    [self.mainView setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(bottom.frame) + 64)];
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
    CGFloat todoHeight = 0;
    if (self.todos.count > 3) {
        todoHeight = groupCellHeight + 3 * conetentCellHeight;
    } else {
         todoHeight = groupCellHeight + self.todos.count * conetentCellHeight;
    }
    self.todoView.frame = CGRectMake(magin, 0, self.view.width - magin * 2, todoHeight);

    // 修改底部菜单frame
    self.bottom.y = CGRectGetMaxY(self.todoView.frame) + 8;
    
    // 设置滚动范围
    [self.mainView setContentSize:CGSizeMake(DeviceWidth, CGRectGetMaxY(self.bottom.frame) + 64)];
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
        vc = [YTNormalWebController webWithTitle:@"关于私募云" url:[NSString stringWithFormat:@"%@/about/?ver=4.0&t=%@", YTH5Server, [NSDate stringDate]]];
        ((YTNormalWebController *)vc).isDate = YES;
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
        // 获取根控制器
        [YTCenter postNotificationName:YTJumpToTodoList object:nil];
        YTTabBarController *appRootVC = (YTTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [appRootVC setSelectedIndex:0];
        [MobClick event:@"main_click" attributes:@{@"按钮" : @"全部待办", @"机构" : [YTUserInfoTool userInfo].organizationName}];
    } else {
        YTMessageModel *message = self.todos[row];

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
- (void)didSelectedRow:(int)row
{
    UIViewController *vc = nil;
    switch (row) {
        case 0:
            vc = [[YTOrderCenterController alloc] init];
            [MobClick event:@"main_click" attributes:@{@"按钮" : @"全部订单", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case 1:
            vc = [YTNormalWebController webWithTitle:@"我的奖品" url:[NSString stringWithFormat:@"%@/prizes%@", YTH5Server,[NSDate stringDate]]];
            [MobClick event:@"main_click" attributes:@{@"按钮" : @"我的奖品", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
        case 2:
            vc = [YTNormalWebController webWithTitle:@"云豆银行" url:[NSString stringWithFormat:@"%@/mall%@", YTH5Server,[NSDate stringDate]]];
            [MobClick event:@"main_click" attributes:@{@"云豆银行" : @"我的奖品", @"机构" : [YTUserInfoTool userInfo].organizationName}];
            break;
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
    if(self.blackAlert != nil) return;
    YTBlackAlertView *alert = [YTBlackAlertView shared];
    self.blackAlert = alert;
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
                YTInformationWebViewController *normal = [YTInformationWebViewController webWithTitle:@"早知道" url:[NSString stringWithFormat:@"%@/information%@&id=%@",YTH5Server, [NSDate stringDate], infoId]];
                normal.isDate = YES;
                normal.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:normal animated:YES];
            }
        }];
    } failure:^(NSError *error) {
        self.blackAlert = nil;
    }];
}
/**
 *  认证
 *
 */
- (void)Authentication
{
    if ([YTUserInfoTool userInfo].phoneNumer == nil && [YTUserInfoTool userInfo].phoneNumer.length == 0) {
        YTBindingPhoneController *bing = [[YTBindingPhoneController alloc] init];
        bing.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bing animated:YES];
        return;
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
                [YTUserInfoTool loadNewUserInfo:^(BOOL result) {
                    if (result) {
                        self.topView.userInfo = [YTUserInfoTool userInfo];
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
    share.share_title = @"推荐私募云";
    share.share_content = @"聚合财富管理力量 成就资产管理价值";
    share.share_url = @"http://www.simuyun.com/invite/invite.html";
    switch (tag) {
        case ShareButtonTypeWxShare:
            //  微信分享
            [share wxShareWithViewControll:self];
            break;
        case ShareButtonTypeWxPyq:
            //  朋友圈分享
            [share wxpyqShareWithViewControll:self];
            break;
    }
}


#pragma mark - 获取数据

#pragma mark - 懒加载
- (NSMutableArray *)todos
{
    if (!_todos) {
        _todos = [[NSMutableArray alloc] init];
    }
    return _todos;
}


- (void)dealloc
{
    [YTCenter removeObserver:self];
}

@end
