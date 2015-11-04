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
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
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




@end
