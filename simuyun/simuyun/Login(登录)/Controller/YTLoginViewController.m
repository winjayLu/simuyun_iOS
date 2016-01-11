//
//  YTLoginViewController.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
#import "UIBarButtonItem+Extension.h"
#import "YTLoginViewController.h"
#import "UMSocial.h"
#import "UMSocialDataService.h"
#import "UMSocialWechatHandler.h"
#import "YTTabBarController.h"
#import "CALayer+Transition.h"
#import "SVProgressHUD.h"
#import "UINavigationBar+BackgroundColor.h"
#import "YTRegisterViewController.h"
#import "YTResultPasswordViewController.h"
#import "YTAccountTool.h"
#import "AFNetworking.h"
#import "YTResourcesTool.h"
#import "APService.h"
#import "NSString+Password.h"
#import "YTUserInfoTool.h"
#import "CoreArchive.h"
#import "HHAlertView.h"


// 登录
@interface YTLoginViewController ()

/**
 *  微信按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;

/**
 *  微信登录单击事件
 */
- (IBAction)weChatClick:(id)sender;

/**
 *  登录按钮单击事件
 *
 */
- (IBAction)loginClick:(UIButton *)sender;
/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *userName;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *passWord;

/**
 *  注册
 *
 */
- (IBAction)registerClick:(UIButton *)sender;
/**
 *  忘记密码
 *
 */
- (IBAction)ForgetClick:(UIButton *)sender;
/**
 *  微信登录面板
 */
@property (weak, nonatomic) IBOutlet UIView *weiChatView;

@end

@implementation YTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    // 修改textField占位文字颜色
    [self.userName setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.passWord setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    
    // 设置导航栏
    [self setupNav];
    
    // iphoe 4 隐藏微信登录提示语
    if (DeviceHight < 568) {
        for (UIView *view in self.weiChatView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                view.hidden = NO;
            } else {
                view.hidden = YES;
            }
        }
    }
    
    // 审核阶段
    if([YTResourcesTool isVersionFlag] == NO)
    {
        self.weiChatView.hidden = YES;
    }
    
    // 是否有帐号信息
    NSString *userName = [CoreArchive strForKey:@"userName"];
    if (userName != nil && userName.length > 0) {
        self.userName.text = userName;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  微信登录单击事件
 */
- (IBAction)weChatClick:(id)sender {
    
    [MobClick event:@"logReg_click" attributes: @{@"按钮" : @"微信登录"}];
    
    // 发起登录
    [self loginWeChat];
}

/**
 *  微信登录
 */
- (void)loginWeChat
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //  友盟微信登录
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *account = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            param[@"nickname"] = account.userName;
            param[@"unionid"] = account.unionId;
            param[@"openid"] = account.openId;
            param[@"headimgurl"] = account.iconURL;

            // 查询unid是否存在
            [self selectWeChatUnid:param];
        } else {
            [SVProgressHUD showWithStatus:@"授权失败"];
        }
    });
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        // 进入到微信
        param[@"sex"] = response.data[@"gender"];
        param[@"address"] = response.data[@"location"];
    }];
}

/**
 *  查询unid是否存在
 */
- (void)selectWeChatUnid:(NSMutableDictionary *)dict
{
    [SVProgressHUD showWithStatus:@"正在授权" maskType:SVProgressHUDMaskTypeClear];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"unionid"] = dict[@"unionid"];
    [YTHttpTool get:YTWeChatUnionId params:param success:^(id responseObject) {
        [SVProgressHUD dismiss];
        // "0":该unionId不存在     "1":该unionId存在
        if ([responseObject[@"isExist"] isEqualToString:@"0"]) {
            [self confirmWeChat:dict];
        } else {
            [self sendWeChatLogin:dict];
        }
    } failure:^(NSError *error) {
    }];
}
/**
 *  二次确认是否使用微信登录
 *
 */
- (void)confirmWeChat:(NSMutableDictionary *)param
{
    HHAlertView *alert = [HHAlertView shared];
    [alert showAlertWithStyle:HHAlertStyleJpush imageName:@"pushIconDock" Title:@"微信登录" detail:[NSString stringWithFormat:@"您将使用微信号：%@创建一个新的私募云账号", param[@"nickname"]] cancelButton:@"取消" Okbutton:@"确认" block:^(HHAlertButton buttonindex) {
        if(buttonindex == HHAlertButtonOk)
        {
            [self sendWeChatLogin:param];
        } else {
            [SVProgressHUD showInfoWithStatus:@"授权取消"];
        }
    }];
}


/**
 *  发起微信登录
 */
- (void)sendWeChatLogin:(NSMutableDictionary *)param
{
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    [YTHttpTool post:YTWeChatLogin params:param success:^(id responseObject) {
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        YTAccount *acc = [[YTAccount alloc] init];
        acc.userName = responseObject[@"username"];
        acc.password = responseObject[@"password"];
        params[@"username"] = acc.userName;
        params[@"password"] = acc.password;
        
        // 2.发送一个POST请求
        NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTSession];
        [mgr POST:newUrl parameters:[NSDictionary httpWithDictionary:params]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // 保存账户信息
              acc.userId = responseObject[@"userId"];
              acc.token = responseObject[@"token"];
              [YTAccountTool save:acc];
              [YTUserInfoTool loadNewUserInfo:^(BOOL finally) {
                  if (finally) {
                      [SVProgressHUD dismiss];
                      [self transitionTabBarVC];
                  }
              }];
              [APService setAlias:responseObject[@"userId"] callbackSelector:nil object:nil];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if(operation.responseObject[@"message"] != nil)
              {
                  if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                      [YTHttpTool tokenError];
                  } else {
                      [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
                  }
              } else if(error.userInfo[@"NSLocalizedDescription"] != nil)
              {
                  [SVProgressHUD showInfoWithStatus:@"网络链接失败\n请稍候再试"];
              } else {
                  [SVProgressHUD dismiss];
              }
          }];
    } failure:^(NSError *error) {
        
    }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    
}

/**
 *  登录按钮单击事件
 *
 */
- (IBAction)loginClick:(UIButton *)sender {
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];

    // 本地验证
    if ([self checkText]) return;
    
    YTAccount *account = [[YTAccount alloc] init];
    account.userName = self.userName.text;
    
    account.password = [NSString md5:self.passWord.text];
    // 发起登录
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeClear];
    [YTAccountTool loginAccount:account result:^(BOOL result) {
        if (result) {   // 登录成功
            [SVProgressHUD dismiss];
            [self transitionTabBarVC];
        } else {
        }
    }];
    [MobClick event:@"logReg_click" attributes: @{@"按钮" : @"登录"}];
}
/**
 *  转场到主界面
 */
- (void)transitionTabBarVC
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.rootViewController = [[YTTabBarController alloc] init];
    [mainWindow.layer transitionWithAnimType:TransitionAnimTypeCube subType:TransitionSubtypesFromRight curve:TransitionCurveEaseOut duration:0.75f];
}



/**
 *  注册
 *
 */
- (IBAction)registerClick:(UIButton *)sender {
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    YTRegisterViewController *registerVc = [[YTRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
    [MobClick event:@"logReg_click" attributes: @{@"按钮" : @"注册"}];
}
/**
 *  忘记密码
 *
 */
- (IBAction)ForgetClick:(UIButton *)sender {
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    YTResultPasswordViewController *resultVc = [[YTResultPasswordViewController alloc] init];
    [self.navigationController pushViewController:resultVc animated:YES];
    [MobClick event:@"logReg_click" attributes: @{@"按钮" : @"忘记密码"}];
}

#pragma mark - NavigationController

/**
 *  设置导航栏状态
 */
- (void)setupNav
{
    // 设置为半透明
    [self.navigationController.navigationBar lt_setBackgroundColor:[YTColor(255, 255, 255) colorWithAlphaComponent:0.0]];
    // 隐藏子控件
    [self navigationBarWithHidden:YES];
    
}
/**
 *  隐藏/显示navgatinonBar的子控件
 */
- (void)navigationBarWithHidden:(BOOL)hidden
{
    NSArray *list=self.navigationController.navigationBar.subviews;
    for (id obj in list) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView=(UIImageView *)obj;
            imageView.hidden=hidden;
        }
    }
}

#pragma mark - 验证
// 本地验证
- (BOOL)checkText
{
    // 本地验证
    if (self.userName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
        return YES;
    } else if(self.passWord.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return YES;
    }
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



@end
