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
#import "YTAuthenticationModel.h"
#import "YTAuthenticationStatusController.h"
#import "AutocompletionTableView.h"


@interface YTBindingPhoneController ()

// 姓名
@property (weak, nonatomic) IBOutlet UITextField *userNameLable;
// 机构名称
@property (weak, nonatomic) IBOutlet UITextField *mechanismNameLable;


/**
 *  申请认证
 *
 */
- (IBAction)applyClick:(UIButton *)sender;

/**
 *  推荐人
 *
 */
@property (weak, nonatomic) IBOutlet UITextField *tuijianLabel;
// 手机号
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
// 验证码
@property (weak, nonatomic) IBOutlet UITextField *yanzhenField;

/**
 *  机构列表
 *
 */
@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
/**
 *  机构模型数组
 *
 */@property (nonatomic, strong) NSArray *orgnazations;

/**
 *  机构名称数组
 *
 */
@property (nonatomic, strong) NSMutableArray *orgnaNames;


// 发送验证码
- (IBAction)sendYanzheng:(JKCountDownButton *)sender;

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
    self.title = @"认证理财师";
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
 *  申请认证
 *
 */
- (IBAction)applyClick:(UIButton *)sender
{

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
    } else if(![self.captcha isEqualToString:self.yanzhenField.text])
    {
        [SVProgressHUD showErrorWithStatus:@"验证码不正确"];
        return;
    }
    

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

        return @[tfm1, tfm2];
    }];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [CoreTFManagerVC uninstallManagerForVC:self];
}





@end
