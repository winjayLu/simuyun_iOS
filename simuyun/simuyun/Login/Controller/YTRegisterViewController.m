//
//  YTRegisterViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/16.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTRegisterViewController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIBarButtonItem+Extension.h"
#import "SVProgressHUD.h"
#import "JKCountDownButton.h"
#import "CoreTFManagerVC.h"
#import "YTAccountTool.h"
#import "YTTabBarController.h"
#import "CALayer+Anim.h"
#import "CALayer+Transition.h"
#import "NSString+Password.h"
#import "YTLoginAuthenticationController.h"

// 注册


@interface YTRegisterViewController ()

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *userName;

/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password;
/**
 *  验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *registerNumber;
/**
 *  发送验证码按钮
 */
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendBtn;

/**
 *  发送验证码单击
 *
 */
- (IBAction)sendClick:(UIButton *)sender;


/**
 *  注册按钮单击
 */
- (IBAction)registerClick:(UIButton *)sender;

/**
 *  验证码
 */
@property (nonatomic, copy) NSString *captcha;



@end

@implementation YTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航栏状态
    [self setupNav];
    [self.navigationItem setHidesBackButton:YES];
    
    // 修改textField占位文字颜色
    [self.userName setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.registerNumber setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
}
/**
 *  发送验证码单击
 *
 */
- (IBAction)sendClick:(JKCountDownButton *)sender {
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    // 本地验证
    if ([self checkTextWith:NO]) return;
    // 设置倒计时时长
    sender.enabled = NO;
    [sender startWithSecond:60];
    // 修改按钮的标题
    [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
        NSString *title = [NSString stringWithFormat:@"%d秒后重发",second];
        return title;
    }];
    [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
        countDownButton.enabled = YES;
        [sender setTitleColor:YTColor(215, 58, 46) forState:UIControlStateNormal];
        [sender setBackgroundImage:[UIImage imageNamed:@"yanzhengmakuang"] forState:UIControlStateNormal];
        return @"重新获取";
    }];

    // 向服务器发送验证码
    [self sendRegisterNumber];
}
/**
 *  注册按钮单击
 */
- (IBAction)registerClick:(UIButton *)sender {

    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    if ([self checkTextWith:YES]) return;
    
    // 帐号模型
    YTAccount *account = [[YTAccount alloc] init];
    account.userName = self.userName.text;
    account.password = [NSString md5:self.password.text];
    
    // 请求参数
    NSDictionary *params = @{@"username" : account.userName, @"password" : account.password};
    [SVProgressHUD showWithStatus:@"正在注册" maskType:SVProgressHUDMaskTypeClear];
    [YTHttpTool post:YTRegister params:params success:^(id responseObject) {
        // 发起登录
        
        account.password = [NSString md5:self.password.text];
        [YTAccountTool loginAccount:account result:^(BOOL result) {
            [SVProgressHUD dismiss];
            if (result) {   // 登录成功
                [self transitionTabBarVC];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } failure:^(NSError *error) {
    }];
    [MobClick event:@"logReg_click" attributes: @{@"按钮" : @"注册"}];
}
/**
 *  转场到主界面
 */
- (void)transitionTabBarVC
{
    YTLoginAuthenticationController *authen = [[YTLoginAuthenticationController alloc] init];
    
    [self.navigationController pushViewController:authen animated:YES];
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


#pragma mark - sendServer
/**
 *  发送验证码
 */
- (void)sendRegisterNumber
{
    NSDictionary *dict = @{@"phone" : self.userName.text, @"checkPhoneDuplicate" : @1};
    [YTHttpTool post:YTCaptcha params:dict success:^(id responseObject) {
        self.captcha = responseObject[@"captcha"];
    } failure:^(NSError *error) {
        [self.sendBtn stop];
    }];
    [MobClick event:@"logReg_click" attributes: @{@"按钮" : @"发送验证码"}];
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


#pragma mark - 验证
/**
 *  本地验证
 *
 *  @param zhuCe 是否是注册
 */
- (BOOL)checkTextWith:(BOOL)zhuCe
{
    // 本地验证
    if (self.userName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return YES;
    } else if(self.password.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return YES;
    } else if(self.userName.text.length < 11)
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码不正确"];
        return YES;
    } else if(self.password.text.length < 8)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入8-14位密码"];
        return YES;
    }
#warning 测试
//    if(zhuCe) {
//        if (self.registerNumber.text.length == 0) {
//            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
//            return YES;
//        }
//        if(![self.registerNumber.text isEqualToString:self.captcha])
//        {
//            [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
//            return YES;
//        }
//    }
    return NO;
}


#pragma mark - 键盘与文本框的处理

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:self.userName inputView:nil name:@"" insetBottom:0];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.password inputView:nil name:@"" insetBottom:0];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.registerNumber inputView:nil name:@"" insetBottom:0];
        return @[tfm1,tfm2,tfm3];
        
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
