//
//  YTBindingPhoneController.m
//  simuyun
//
//  Created by Luwinjay on 15/11/3.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBindingPhoneController.h"
#import "JKCountDownButton.h"
#import "SVProgressHUD.h"
#import "YTAccountTool.h"
#import "YTAuthenticationViewController.h"
#import "YTUserInfoTool.h"
#import "NSString+Password.h"
#import "CoreTFManagerVC.h"

@interface YTBindingPhoneController ()

// 手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

// 验证码
@property (weak, nonatomic) IBOutlet UITextField *yanzhenField;

// 发送验证码
- (IBAction)sendYanzheng:(JKCountDownButton *)sender;

// 密码
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

// 下一步
- (IBAction)nextClick:(UIButton *)sender;

/**
 *  验证码
 */
@property (nonatomic, copy) NSString *captcha;

// 验证码按钮
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendBtn;



@end

@implementation YTBindingPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关联手机";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)sendYanzheng:(JKCountDownButton *)sender {
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    // 本地验证
    if (self.phoneField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    }
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
 *  发送验证码
 */
- (void)sendRegisterNumber
{
    NSDictionary *dict = @{@"phone" : self.phoneField.text, @"checkPhoneDuplicate" : @1};
    [YTHttpTool post:YTCaptcha params:dict success:^(id responseObject) {
        self.captcha = responseObject[@"captcha"];
    } failure:^(NSError *error) {
        [self.sendBtn stop];
    }];
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


- (IBAction)nextClick:(UIButton *)sender {
    
    // 校验
    if (self.phoneField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号"];
        return;
    } else if (self.yanzhenField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    } else if(self.passwordField.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    } else if(![self.captcha isEqualToString:self.yanzhenField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return;
    }
    
    // 发送请求
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"adviserId"] = [YTAccountTool account].userId;
    param[@"phoneNumber"] = self.phoneField.text;
    param[@"password"] = [NSString md5:self.passwordField.text];
    [SVProgressHUD showWithStatus:@"正在绑定" maskType:SVProgressHUDMaskTypeClear];
    [YTHttpTool post:YTBindPhone params:param success:^(id responseObject) {
        [SVProgressHUD dismiss];
        // 修改本地存储的帐号信息
        YTAccount *account = [YTAccountTool account];
        account.userName = self.phoneField.text;
        account.password = [NSString md5:self.passwordField.text];
        [YTAccountTool save:account];
        
        YTAuthenticationViewController *authen = [[YTAuthenticationViewController alloc] init];
        authen.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:authen animated:YES];
        [self updateUserInfo];
    } failure:^(NSError *error) {

    }];
}

// 修改用户信息
- (void)updateUserInfo
{
    [YTCenter postNotificationName:YTUpdateUserInfo object:nil];
    YTUserInfo *userInfo =[YTUserInfoTool userInfo];
    userInfo.phoneNumer = self.phoneField.text;
    [YTUserInfoTool saveUserInfo:userInfo];
}

#pragma mark - 键盘与文本框的处理

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    [CoreTFManagerVC installManagerForVC:self scrollView:nil tfModels:^NSArray *{
        
        TFModel *tfm1=[TFModel modelWithTextFiled:self.phoneField inputView:nil name:@"" insetBottom:12];
        TFModel *tfm2=[TFModel modelWithTextFiled:self.yanzhenField inputView:nil name:@"" insetBottom:12];
        TFModel *tfm3=[TFModel modelWithTextFiled:self.passwordField inputView:nil name:@"" insetBottom:12];
        return @[tfm1, tfm2, tfm3];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}





@end
