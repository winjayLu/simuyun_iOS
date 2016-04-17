//
//  YTAuthenCodeView.m
//  simuyun
//
//  Created by Luwinjay on 16/4/15.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTAuthenCodeView.h"
#import "ShareManage.h"
#import "SVProgressHUD.h"

#define authenWH  310

@interface YTAuthenCodeView()

/**
 *  分享
 */
@property (nonatomic, strong) ShareManage *shareManage;

/**
 *  控制器
 */
@property (nonatomic, weak) UIViewController *vc;

@end

// 认证口令

@implementation YTAuthenCodeView


+ (instancetype)hiddenAlloc
{
    return [super alloc];
}


+ (instancetype)shared
{
    
    static dispatch_once_t once = 0;
    static YTAuthenCodeView *authen;
    dispatch_once(&once, ^{
        authen = [[self hiddenAlloc] init];
    });
    return authen;
}



static UIWindow *_window;
- (void)showScanWithVc:(UIViewController *)vc
{
    [self destroy];
    self.vc = vc;
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _window.backgroundColor = YTRGBA(0, 0, 0, 0.4);
    _window.alpha = 1;
    _window.windowLevel = 4000;
    _window.hidden = NO;
    [_window makeKeyAndVisible];
    
    // 背景按钮
    UIButton *button = [[UIButton alloc] initWithFrame:_window.bounds];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(destroy) forControlEvents:UIControlEventTouchUpInside];
    [_window addSubview:button];

    // 初始化
    [self setup];
    
    // 弹框
    [self setFrame:CGRectMake((DeviceWidth - authenWH) * 0.5, (DeviceHight- authenWH) * 0.5 - 20, authenWH, authenWH)];
    self.alpha = 0;
    [self setBackgroundColor:[UIColor whiteColor]];
    [_window addSubview:self];
    
    // 过期日期
    [self show];
}

- (void)setup
{
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"理财师召集令";
    title.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.frame = CGRectMake((authenWH - title.width) *  0.5, 30, title.width, title.height);
    [self addSubview:title];
    
    // 左侧红旗
    UIImageView *leftQi = [[UIImageView alloc] init];
    leftQi.image = [UIImage imageNamed:@"authenHongqileft"];
    leftQi.size = leftQi.image.size;
    leftQi.center = title.center;
    leftQi.x = title.x - leftQi.width - 7;
    [self addSubview:leftQi];
    
    // 右侧红旗
    UIImageView *rightQi = [[UIImageView alloc] init];
    rightQi.image = [UIImage imageNamed:@"authenHongqiright"];
    rightQi.size = rightQi.image.size;
    rightQi.center = title.center;
    rightQi.x = CGRectGetMaxX(title.frame) + 5;
    [self addSubview:rightQi];
    
    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(202, 202, 202);
    line.frame = CGRectMake(0, authenWH - 110, authenWH, 1);
    [self addSubview:line];

    // 展示内容
    UILabel *content = [[UILabel alloc] init];
    if (self.content.length > 0) {
        content.attributedText = [self attributedStringWithStr:self.content];
    }
    content.numberOfLines = 0;
    content.textColor = YTColor(51, 51, 51);
    CGFloat contentY = CGRectGetMaxY(title.frame) + 20;
    content.frame = CGRectMake(25, contentY, authenWH - 50, line.y - contentY - 20);
    [self addSubview:content];
    
    
    // 短信分享
    UIButton *smsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [smsBtn setImage:[UIImage imageNamed:@"authenSms"] forState:UIControlStateNormal];
    [smsBtn addTarget:self action:@selector(smsClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:smsBtn];
    //  设置文字
    UILabel *smsTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 12)];
    smsTitle.font = [UIFont systemFontOfSize:10];
    smsTitle.textAlignment = NSTextAlignmentCenter;
    smsTitle.textColor = YTColor(51, 51, 51);
    smsTitle.text = @"短信";
    [self addSubview:smsTitle];
    [smsTitle sizeToFit];
    smsBtn.frame = CGRectMake((authenWH * 0.5) -  75, CGRectGetMaxY(line.frame) + 20, 50, 50);
    smsTitle.center = CGPointMake(smsBtn.center.x, smsBtn.center.y + 35);
    
    
    // 微信分享按钮
//    UIButton *weChat = [UIButton buttonWithType:UIButtonTypeCustom];
//    [weChat setImage:[UIImage imageNamed:@"Share_ScanWexin"] forState:UIControlStateNormal];
//    [weChat addTarget:self action:@selector(weChatClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:weChat];
//    //  设置文字
//    UILabel *weChatTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 12)];
//    weChatTitle.font = [UIFont systemFontOfSize:10];
//    weChatTitle.textAlignment = NSTextAlignmentCenter;
//    weChatTitle.textColor = YTColor(51, 51, 51);
//    weChatTitle.text = @"微信";
//    [self addSubview:weChatTitle];
//    [weChatTitle sizeToFit];
//    weChat.frame = CGRectMake(smsBtn.x - 80, CGRectGetMaxY(line.frame) + 20, 50, 50);
//    weChatTitle.center = CGPointMake(weChat.center.x, weChat.center.y + 35);
    
    
    // 复制按钮
    UIButton *weChatQuan = [UIButton buttonWithType:UIButtonTypeCustom];
    [weChatQuan setImage:[UIImage imageNamed:@"authenCopy"] forState:UIControlStateNormal];
    [weChatQuan addTarget:self action:@selector(copyPasteboard) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weChatQuan];
    //  设置文字
    UILabel *weChatQuanTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 12)];
    weChatQuanTitle.font = [UIFont systemFontOfSize:10];
    weChatQuanTitle.textAlignment = NSTextAlignmentCenter;
    weChatQuanTitle.textColor = YTColor(51, 51, 51);
    weChatQuanTitle.text = @"复制";
    [self addSubview:weChatQuanTitle];
    [weChatQuanTitle sizeToFit];
    weChatQuan.frame = CGRectMake(CGRectGetMaxX(smsBtn.frame) + 50, CGRectGetMaxY(line.frame) + 20, 50, 50);
    weChatQuanTitle.center = CGPointMake(weChatQuan.center.x, weChatQuan.center.y + 35);
}
#warning 去除微信分享  测试
/**
 *  分享到微信
 */
//- (void)weChatClick
//{
//    self.shareManage.share_content = self.content;
//    [self.shareManage wxShareWithViewControll:self.vc];
//    [self destroy];
//}

- (void)smsClick
{
    self.shareManage.bankNumber = self.content;
    [self.shareManage smsShareWithViewControll:self.vc];
    [self destroy];
}
/**
 *  复制到剪贴板
 */
- (void)copyPasteboard
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.content;
    [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    [self destroy];
}

- (NSMutableAttributedString *)attributedStringWithStr:(NSString *)str
{
    //创建NSMutableAttributedString实例，并将text传入
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:str];
    //创建NSMutableParagraphStyle实例
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    //设置行距
    [style setLineSpacing:4.0f];
    
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attStr.length)];
    
    //根据给定长度与style设置attStr式样]
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
    return attStr;
}


- (void)show
{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.windowLevel == 0) {
            [window endEditing:YES];
            break;
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=1;
        self.layer.cornerRadius = 10;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowRadius = 20.0f;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)destroy
{
    self.alpha=0;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
    self.shareManage = nil;
    _window.hidden = YES;
    _window = nil;
}

- (ShareManage *)shareManage
{
    if (!_shareManage) {
        ShareManage *share = [ShareManage shareManage];
        [share shareTextConfig];
        share.share_title = nil;
        share.share_image = nil;
        share.share_url = nil;
        _shareManage = share;
    }
    return _shareManage;
}
@end
