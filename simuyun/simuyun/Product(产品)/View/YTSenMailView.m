//
//  YTSenMailView.m
//  simuyun
//
//  Created by Luwinjay on 15/11/2.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTSenMailView.h"
#import "UIImage+Extend.h"
#import "CoreTFManagerVC.h"
#import "SVProgressHUD.h"
#import "YTUserInfoTool.h"

@interface YTSenMailView()
{
    UIView *shareMenuView;
    UIImageView *mainGrayBg;
    UILabel *shareToLabel1;
    UILabel *shareTolabel2;
    UIButton *cancelBtn;
    UILabel  *titleLabel;
    BOOL   isNight;
    
    
}
@property(nonatomic,retain)UIImageView *whiteBg;

@property (nonatomic, weak) UITextField *mailField;

@end


@implementation YTSenMailView


- (instancetype)initWithViewController:(UIViewController *)vc
{
    self = [self init];
    if (self) {
        //  创建子控件
        [self creatMainShareView:vc];
        [self.mailField becomeFirstResponder];
    }
    return self;
}

- (void)creatMainShareView:(UIViewController *)vc
{
    mainGrayBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHight)];
    [mainGrayBg setImage:[UIImage imageWithColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]]];
    
    [mainGrayBg  setUserInteractionEnabled:YES];
    mainGrayBg.alpha = 0.0;
    [self addSubview:mainGrayBg];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnClick:)];
    
    [mainGrayBg  addGestureRecognizer:tapGR];
    
    CGFloat shareMenuViewH = 263;
    
    shareMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHight, DeviceWidth, shareMenuViewH)];
    [self addSubview:shareMenuView];
    
    [UIView animateWithDuration:0.4 animations:^{
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            shareMenuView.frame =CGRectMake(0,DeviceHight - shareMenuViewH, DeviceWidth,shareMenuViewH);
        } else {
            shareMenuView.frame =CGRectMake(0,DeviceHight - shareMenuViewH - 256, DeviceWidth,shareMenuViewH);
        }
        
        mainGrayBg.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
    _whiteBg = [[UIImageView alloc] initWithFrame:shareMenuView.bounds];
    [_whiteBg  setUserInteractionEnabled:YES];
    _whiteBg.backgroundColor = YTColor(246, 246, 246);
    [shareMenuView addSubview:_whiteBg];
    [self creatSubview:vc];
}

- (void)creatSubview:(UIViewController *)vc
{
    // 提示
    UILabel *lable = [[UILabel alloc] init];
    lable.text = @"详细资料包括：电子合同、电子版产品说明书、产品简版、产品背景资料、签约指引、预热短信。";
    lable.numberOfLines = 0;
    lable.textColor = YTColor(102, 102, 102);
    lable.font = [UIFont systemFontOfSize:13];
    lable.frame = CGRectMake(10, 20, DeviceWidth - 20, 0);
    [lable sizeToFit];
    [_whiteBg addSubview:lable];
    
    // 文本框父控件
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, CGRectGetMaxY(lable.frame) + 15, DeviceWidth, 54);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = YTColor(208, 208, 208).CGColor;
    [_whiteBg addSubview:view];
    
    // 文本框
    UITextField *mailField = [[UITextField alloc] init];
    [mailField setValue:YTColor(204, 204, 204) forKeyPath:@"_placeholderLabel.textColor"];
    mailField.placeholder = @"输入常用邮箱";
    mailField.textColor = [UIColor blackColor];
    mailField.font = [UIFont systemFontOfSize:13];
    mailField.frame = CGRectMake(10, 0, view.width - 20, view.height);
    mailField.keyboardType = UIKeyboardTypeEmailAddress;
    [view addSubview:mailField];
    self.mailField = mailField;
    [CoreTFManagerVC installManagerForVC:vc scrollView:nil tfModels:^NSArray *{
        TFModel *tfm1=[TFModel modelWithTextFiled:mailField inputView:nil name:@"" insetBottom:140];
        return @[tfm1];
    }];
    // 获取用户邮箱
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    if (userInfo != nil && userInfo.email.length > 0) {
        mailField.text = userInfo.email;
    }
    
    // 按钮
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"hongseanniu"] forState:UIControlStateNormal];
    [button setTitle:@"获取详细资料" forState:UIControlStateNormal];
    button.adjustsImageWhenHighlighted = NO;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, CGRectGetMaxY(view.frame) + 15, DeviceWidth - 20, 44);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [_whiteBg addSubview:button];
}

// 获取按钮
- (void)buttonClick
{
    if (self.mailField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入邮箱地址"];
        return;
    }
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
    [self.sendDelegate sendMail:self.mailField.text];
    [self cancelBtnClick:nil];
}

#pragma mark 取消分享
- (void)cancelBtnClick:(UIImageView *)sender
{
    // 退出键盘
    [[[UIApplication sharedApplication] keyWindow]endEditing:YES];
//    if (self.mailField.text.length > 0) return;
    
    [UIView animateWithDuration:0.4 animations:^{
        shareMenuView.frame =CGRectMake(0, DeviceHight - 20, DeviceHight, 150);
        mainGrayBg.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
