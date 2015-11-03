//
//  YTBindingPhoneController.m
//  simuyun
//
//  Created by Luwinjay on 15/11/3.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBindingPhoneController.h"
#import "JKCountDownButton.h"

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
    
    
}
- (IBAction)nextClick:(UIButton *)sender {
    
    
}
@end
