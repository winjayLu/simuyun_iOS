//
//  YTResuNextViewController.m
//  simuyun
//
//  Created by Luwinjay on 15/10/16.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTResuNextViewController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "UIBarButtonItem+Extension.h"

@interface YTResuNextViewController ()

/**
 *  密码
 */
@property (weak, nonatomic) IBOutlet UITextField *password;

/**
 *  确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *nextPassword;

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
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
