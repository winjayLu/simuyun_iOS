//
//  YTLeftMenu.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTLeftMenu.h"
#import "UIImageView+SD.h"
#import "YTLoginViewController.h"
#import "YTAccountTool.h"
#import "YTUserInfoTool.h"
#import "YTResourcesTool.h"
#import "YTNavigationController.h"

@interface YTLeftMenu()

/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

/**
 *  用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

/**
 *  用户资料单击事件
 *
 */
- (IBAction)ziLiaoClick:(UIButton *)sender;

/**
 *  关联微信按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *guanLianBtn;

/**
 *  关联微信单击事件
 *
 */
- (IBAction)guanLianClick:(UIButton *)sender;

/**
 *  邮寄地址单击事件
 *
 */
//- (IBAction)youJiClick:(UIButton *)sender;

/**
 *  推荐私募云单击事件
 *
 */
- (IBAction)tuiJian:(UIButton *)sender;

/**
 *  帮助单击事件
 *
 */
- (IBAction)bangZhuClick:(UIButton *)sender;

/**
 *  关于单击事件
 *
 */
- (IBAction)guanYuClick:(UIButton *)sender;

/**
 *  退出单击事件
 *
 */
- (IBAction)tuiChuClick:(UIButton *)sender;
/**
 *  拨打电话
 *
 */
- (IBAction)phoneClick:(UIButton *)sender;

// 皇冠
@property (weak, nonatomic) IBOutlet UIImageView *huangGuanImage;
@end


@implementation YTLeftMenu


+ (instancetype)leftMenu
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTLeftMenu" owner:nil options:nil] firstObject];
}
/**
 *  用户资料单击事件
 *
 */
- (IBAction)ziLiaoClick:(UIButton *)sender {
    
    [self senderNotification:sender];
}
/**
 *  关联微信单击事件
 *
 */
- (IBAction)guanLianClick:(UIButton *)sender {
    [self senderNotification:sender];
}

/**
 *  邮寄地址单击事件
 *
 */
//- (IBAction)youJiClick:(UIButton *)sender {
//    [self senderNotification:sender];
//}
/**
 *  推荐私募云单击事件
 *
 */
- (IBAction)tuiJian:(UIButton *)sender {
    [self senderNotification:sender];
}
/**
 *  帮助单击事件
 *
 */
- (IBAction)bangZhuClick:(UIButton *)sender {
    [self senderNotification:sender];
}
/**
 *  关于单击事件
 *
 */
- (IBAction)guanYuClick:(UIButton *)sender {
    [self senderNotification:sender];
}
/**
 *  退出单击事件
 *
 */
- (IBAction)tuiChuClick:(UIButton *)sender {
    [self senderNotification:sender];
    // 获取程序主窗口
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.rootViewController = [[YTNavigationController alloc] initWithRootViewController:[[YTLoginViewController alloc] init]];
    // 清除保存的账户信息
    [YTAccountTool save:nil];
    // 清除用户信息
    [YTUserInfoTool clearUserInfo];
}
/**
 *  拨打电话
 *
 */
- (IBAction)phoneClick:(UIButton *)sender {
    [self senderNotification:sender];
}
/**
 *  发送通知
 */
- (void)senderNotification:(UIButton *)btn
{
    NSDictionary *userInfo = @{YTLeftMenuSelectBtn : btn.titleLabel.text};
    [YTCenter postNotificationName:YTLeftMenuNotification object:nil userInfo:userInfo];
}

- (void)setUserInfo:(YTUserInfo *)userInfo
{
    _userInfo = userInfo;
    
    YTResources *resourse = [YTResourcesTool resources];
    // 隐藏关联 微信
    if (resourse.versionFlag == 0) {
        self.guanLianBtn.hidden = YES;
    }
    if (_userInfo == nil) return;
    // 设置头像
    [self setIconImageWithImageUrl:userInfo.headImgUrl];
    // 认证状态
    if (userInfo.adviserStatus) {
        // 设置昵称
        self.nameLable.text = userInfo.nickName;
    } else {
        // 设置昵称
        if (userInfo.nickName) {
            self.nameLable.text = [NSString stringWithFormat:@"%@ | %@",userInfo.organizationName, userInfo.nickName];
        } else {
            self.nameLable.text = userInfo.organizationName;
        }
    }
    if (userInfo.weChatNickName.length > 0)
    {
        [self.guanLianBtn setTitle:@"已关联微信" forState:UIControlStateNormal];
        self.guanLianBtn.enabled = NO;
    }
    // 理财师等级
    self.huangGuanImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"lv%d",userInfo.adviserLevel]];
}

/**
 *  给iconView设置图片
 */
- (void)setIconImageWithImageUrl:(NSString *)imageUrl
{
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = self.iconImage.frame.size.width * 0.5;
    self.iconImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.iconImage.layer.shouldRasterize = YES;
    self.iconImage.clipsToBounds = YES;
    
    UIImage *placeholder = [UIImage imageNamed:@"avatar_default_big"];
    // 判断是否是更换图片
    if(imageUrl == nil) {
        self.iconImage.image = placeholder;
        return;
    }
    [self.iconImage imageWithUrlStr:imageUrl phImage:placeholder];
}
/**
 *  修改头像
 */
- (void)updateIconImage
{
    self.iconImage.image = [YTUserInfoTool userInfo].iconImage;
}

@end
