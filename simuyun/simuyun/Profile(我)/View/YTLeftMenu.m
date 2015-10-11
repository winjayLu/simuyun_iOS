//
//  YTLeftMenu.m
//  simuyun
//
//  Created by Luwinjay on 15/10/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTLeftMenu.h"


@interface YTLeftMenu()

/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

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
- (IBAction)youJiClick:(UIButton *)sender;

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
- (IBAction)youJiClick:(UIButton *)sender {
    [self senderNotification:sender];
}
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
}
/**
 *  发送通知
 */
- (void)senderNotification:(UIButton *)btn
{
    NSDictionary *userInfo = @{YTLeftMenuSelectBtn : btn.titleLabel.text};
    [YTCenter postNotificationName:YTLeftMenuNotification object:nil userInfo:userInfo];
}
@end
