//
//  YTSenMailView.m
//  simuyun
//
//  Created by Luwinjay on 15/11/2.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTSenMailView.h"
#import "UIImage+Extend.h"
#import "SVProgressHUD.h"
#import "YTUserInfoTool.h"
#import "CoreArchive.h"

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


- (instancetype)initWithViewController:(UIViewController *)vc tiele:(NSString *)title btnTitle:(NSString *)btnTitle
{
    self = [self init];
    if (self) {
        //  创建子控件
        [self creatMainShareView:vc title:title btnTitle:btnTitle];
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [self.mailField becomeFirstResponder];
    }
    return self;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat shareMenuViewH = keyboardRect.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        mainGrayBg.alpha = 1.0;
        shareMenuView.y = DeviceHight - shareMenuViewH - 263;
    }];
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.4 animations:^{
        mainGrayBg.alpha = 0.0;
        shareMenuView.y = DeviceHight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)creatMainShareView:(UIViewController *)vc title:(NSString *)title btnTitle:(NSString *)btnTitle
{
    mainGrayBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHight)];
    [mainGrayBg setImage:[UIImage imageWithColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2]]];
    
    [mainGrayBg  setUserInteractionEnabled:YES];
    
    [self addSubview:mainGrayBg];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelBtnClick:)];
    
    [mainGrayBg  addGestureRecognizer:tapGR];
    shareMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHight - 263, DeviceWidth, 263)];
    [self addSubview:shareMenuView];

    _whiteBg = [[UIImageView alloc] initWithFrame:shareMenuView.bounds];
    [_whiteBg  setUserInteractionEnabled:YES];
    _whiteBg.backgroundColor = YTColor(246, 246, 246);
    [shareMenuView addSubview:_whiteBg];
    [self creatSubview:vc title:title btnTitle:btnTitle];
}

- (void)creatSubview:(UIViewController *)vc title:(NSString *)title btnTitle:(NSString *)btnTitle
{
    // 提示
    UILabel *lable = [[UILabel alloc] init];
    lable.text = title;
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
    // 获取用户邮箱
    NSString *mail = [CoreArchive strForKey:@"mail"];
    if (mail.length != 0) {
        mailField.text = mail;
    } else {
        YTUserInfo *userInfo = [YTUserInfoTool userInfo];
        if (userInfo != nil && userInfo.email.length > 0) {
            mailField.text = userInfo.email;
        }
    }
    
    // 按钮
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"hongseanniu"] forState:UIControlStateNormal];
    [button setTitle:btnTitle forState:UIControlStateNormal];
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

    [self.sendDelegate sendMail:self.mailField.text];
    
}
- (void)sendSuccess:(BOOL)success
{
    if (success) {
        [self cancelBtnClick:nil];
    }
}


- (void)dealloc
{
    [YTCenter removeObserver:self];
}

#pragma mark 取消分享
- (void)cancelBtnClick:(UIImageView *)sender
{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
}



@end
