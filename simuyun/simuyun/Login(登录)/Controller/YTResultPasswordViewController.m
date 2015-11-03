//
//  YTResultPasswordViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/16.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

// 找回密码

#import "YTResultPasswordViewController.h"
#import "JKCountDownButton.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIBarButtonItem+Extension.h"
#import "YTResuNextViewController.h"
#import "SVProgressHUD.h"

@interface YTResultPasswordViewController ()

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UITextField *userName;
/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password;
/**
 *  发送验证码
 */
@property (weak, nonatomic) IBOutlet JKCountDownButton *sendBtn;
/**
 *  发送验证码单击
 *
 */
- (IBAction)sendClick:(JKCountDownButton *)sender;
/**
 *  下一步按钮单击
 *
 */
- (IBAction)nextBtnClick:(UIButton *)sender;

/**
 *  验证码
 */
@property (nonatomic, copy) NSString *captcha;

@end

@implementation YTResultPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏状态
    [self setupNav];
    [self.navigationItem setHidesBackButton:YES];
    
    // 修改textField占位文字颜色
    [self.userName setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
}

- (IBAction)sendClick:(JKCountDownButton *)sender {
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
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
        [sender setBackgroundImage:[UIImage imageNamed:@"yanzhengmakuang"] forState:UIControlStateNormal];
        return @"重新获取";
        
    }];
    
    // 向服务器发送验证码
    [self sendRegisterNumber];
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    if ([self checkTextWith:YES]) return;
    YTResuNextViewController *next = [[YTResuNextViewController alloc] init];
    next.username = self.userName.text;
    [self.navigationController pushViewController:next animated:YES];
}


#pragma mark - sendServer
/**
 *  发送验证码
 */
- (void)sendRegisterNumber
{
    NSDictionary *dict = @{@"phone" : self.userName.text, @"checkPhoneDuplicate" : @0};
    [YTHttpTool post:YTCaptcha params:dict success:^(id responseObject) {
        self.captcha = responseObject[@"captcha"];
        if (responseObject[@"msg"]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            [self.sendBtn stop];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
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
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
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
 *  @param zhuCe 是否是下一步
 */
- (BOOL)checkTextWith:(BOOL)next
{
    // 本地验证
    if (self.userName.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return YES;
    } else if(self.userName.text.length < 11)
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码不正确"];
        return YES;
    }
    
    if (next) {
        if (self.password.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
            return YES;
        }

        if(![self.password.text isEqualToString:self.captcha])
        {
            [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
            return YES;
        }
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
