//
//  YTResuNextViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/16.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 修改密码

#import "YTResuNextViewController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIBarButtonItem+Extension.h"
#import "SVProgressHUD.h"
#import "YTAccountTool.h"
#import "CALayer+Transition.h"
#import "YTTabBarController.h"
#import "NSString+Password.h"
#import "AFNetworking.h"
#import "YTUserInfoTool.h"

@interface YTResuNextViewController ()

/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password;

/**
 *  确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *nextPassword;

/**
 *  点击确认按钮
 *
 */
- (IBAction)confirmClick:(id)sender;


@end

@implementation YTResuNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化导航栏
    [self setupNav];
    
    // 修改textField占位文字颜色
    [self.password setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.nextPassword setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
}
/**
 *  点击确认按钮
 *
 */

- (IBAction)confirmClick:(id)sender {
    
    if(self.password.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    } else if(self.nextPassword.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
        return;
    } else if (![self.password.text isEqualToString:self.nextPassword.text])
    {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        return;
    }
    // YTresetPassword
    
    // 帐号模型
    YTAccount *account = [[YTAccount alloc] init];
    account.userName = self.username;
    account.password = [NSString md5:self.password.text];
    
    // 请求参数
    NSDictionary *params = @{@"username" : account.userName, @"password" : account.password};
    [SVProgressHUD showWithStatus:@"正在修改" maskType:SVProgressHUDMaskTypeClear];
    [YTHttpTool post:YTresetPassword params:params success:^(id responseObject) {

        
        // 发起登录
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"username"] = account.userName;
        params[@"password"] = account.password;
        
        // 2.发送一个POST请求
        NSString *newUrl = [NSString stringWithFormat:@"%@%@",YTServer, YTSession];
        
        [mgr POST:newUrl parameters:[NSDictionary httpWithDictionary:params]
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // 保存账户信息
              account.userId = responseObject[@"userId"];
              account.token = responseObject[@"token"];
              [YTAccountTool save:account];
              [YTUserInfoTool loadNewUserInfo:^(BOOL finally) {
                  if (finally) {
                      [self transitionTabBarVC];
                  }
              }];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if(operation.responseObject[@"message"] != nil)
              {
                  if ([operation.responseObject[@"message"] isEqualToString:@"tokenError"]) {
                      [YTHttpTool tokenError];
                  } else {
                      [SVProgressHUD showErrorWithStatus:operation.responseObject[@"message"]];
                  }
              }
              [self.navigationController popViewControllerAnimated:YES];
          }];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
}

/**
 *  转场到主界面
 */
- (void)transitionTabBarVC
{
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
    keyWindow.rootViewController = [[YTTabBarController alloc] init];
    [keyWindow.layer transitionWithAnimType:TransitionAnimTypeCube subType:TransitionSubtypesFromRight curve:TransitionCurveEaseOut duration:0.75f];
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
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithBg:@"shanchu" target:self action:@selector(backView)];
}
/**
 *  返回登录界面
 *
 */
- (void)backView
{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
