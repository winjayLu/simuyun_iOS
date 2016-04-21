//
//  YTScanView.m
//  simuyun
//
//  Created by Luwinjay on 16/3/15.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTScanView.h"
#import "YTUserInfoTool.h"
#import "UIImageView+SD.h"
#import "LBXScanWrapper.h"
#import "NSString+Password.h"
#import "NSDate+Extension.h"
#import "YTAccountTool.h"
#import "UIWindow+Extension.h"
#import "ShareManage.h"
#import "SVProgressHUD.h"

#define scanWidth  285
#define scanHeight  475

@interface YTScanView ()

/**
 *  截止日期
 */
@property (weak, nonatomic) UILabel *endDate;

@property (weak, nonatomic) UIImageView *imageV;
@property (weak, nonatomic) UILabel *nickNameLable;

@property (weak, nonatomic) UILabel *jigou;
@property (weak, nonatomic) UIImageView *photo;

@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UILabel *tishi;

/**
 *  分享
 */
@property (nonatomic, strong) ShareManage *shareManage;
@end


@implementation YTScanView


+ (instancetype)hiddenAlloc
{
    return [super alloc];
}

+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static YTScanView *scan;
    dispatch_once(&once, ^{
        scan = [[self hiddenAlloc] init];
    });
    return scan;
}

static UIWindow *_window;
- (void)showScan
{
    [self destroy];
    _window                 = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _window.backgroundColor = YTRGBA(0, 0, 0, 0.4);
    _window.alpha           = 1;
    _window.windowLevel     = 4000;
    _window.hidden          = NO;
    [_window makeKeyAndVisible];

    // 背景按钮
    UIButton *button = [[UIButton alloc] initWithFrame:_window.bounds];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self
               action:@selector(destroy)
     forControlEvents:UIControlEventTouchUpInside];
    [_window addSubview:button];

    // 初始化
    [self setup];

    // 弹框
    [self setFrame:CGRectMake((DeviceWidth - scanWidth) * 0.5, (DeviceHight - scanHeight) * 0.5 - 20, scanWidth, scanHeight)];
    self.alpha = 0;
    [self setBackgroundColor:[UIColor whiteColor]];
    [_window addSubview:self];

    // 过期日期
//    [self setupDate];
    [self show];
}

- (void)setup
{
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    // 头像
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 45, 45)];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius  = 22.5;
    imageV.clipsToBounds       = YES;
    // 设置头像
    if (userInfo.iconImage != nil)
    {
        imageV.image = [YTUserInfoTool userInfo].iconImage;
    }
    else
    {
        [imageV imageWithUrlStr:userInfo.headImgUrl
                        phImage:[UIImage imageNamed:@"avatar_default_big"]];
    }
    [self addSubview:imageV];
    self.imageV = imageV;


    // 昵称
    CGFloat nickLableX     = CGRectGetMaxX(imageV.frame) + 10;
    UILabel *nickNameLable = [[UILabel alloc] init];
    nickNameLable.width     = self.width - nickLableX - 20;
    nickNameLable.font      = [UIFont systemFontOfSize:18];
    nickNameLable.textColor = YTColor(51, 51, 51);
    nickNameLable.text      = userInfo.realName;
    [nickNameLable sizeToFit];
    nickNameLable.x = nickLableX;
    nickNameLable.y = 20;
    [self addSubview:nickNameLable];
    self.nickNameLable = nickNameLable;

    // 机构
    UILabel *jigou = [[UILabel alloc] init];
    jigou.width     = nickNameLable.width;
    jigou.font      = [UIFont systemFontOfSize:14];
    jigou.textColor = YTColor(102, 102, 102);
    jigou.text      = userInfo.organizationName;
    [jigou sizeToFit];
    jigou.x = nickLableX;
    jigou.y = CGRectGetMaxY(nickNameLable.frame) + 8;
    [self addSubview:jigou];
    self.jigou = jigou;

    // 二维码
    UIImageView *photo = [[UIImageView alloc] init];
    CGFloat photoWH    = 187;
    photo.frame = CGRectMake((scanWidth - photoWH) * 0.5, CGRectGetMaxY(imageV.frame) + 10, photoWH, photoWH);
    [self addSubview:photo];
    self.photo = photo;

    // 截止日期
    NSDate *nextDate  = [NSDate dateWithTimeInterval:24 * 60 * 60 * 7
                                           sinceDate:[NSDate date]];
    NSString *dateStr = [nextDate stringWithFormater:@"yyyy-MM-dd"];

    NSString *appendStr = [NSString stringWithFormat:@"{\"party_id\":\"%@\",\"party_name\":\"%@\",\"uid\":\"%@\",\"deadline\":\"%@\",\"nickName\":\"%@\"}", userInfo.organizationId, userInfo.organizationName, [YTAccountTool account].userId, dateStr, [YTUserInfoTool userInfo].realName];

    NSString *content = [NSString stringWithFormat:@"http://www.simuyun.com/?%@", [NSString encrypt:appendStr]];
    // 设置图片
    photo.image = [LBXScanWrapper createQRWithString:content
                                                size:photo.size];

    // logo图片
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image  = [UIImage imageNamed:@"scanlogo"];
    logo.size   = CGSizeMake(38, 38);
    logo.center = photo.center;
    [self addSubview:logo];
    self.logo = logo;

    // 日期
    UILabel *labele = [[UILabel alloc] init];
    labele.textColor = YTColor(51, 51, 51);
    labele.font      = [UIFont systemFontOfSize:10];
    labele.text      = [NSString stringWithFormat:@"该二维码7天内（%@前）有效", [nextDate stringWithFormater:@"MM月dd日"]];
    [labele sizeToFit];
    labele.x = (scanWidth - labele.width) * 0.5;
    labele.y = CGRectGetMaxY(photo.frame) + 10;
    [self addSubview:labele];
    self.endDate = labele;

    // 提示语
    UILabel *tishi = [[UILabel alloc] init];
    tishi.width         = scanWidth - 60;
    tishi.textColor     = YTColor(102, 102, 102);
    tishi.font          = [UIFont systemFontOfSize:14];
    tishi.numberOfLines = 2;
    NSString *text = [NSString stringWithFormat:@"让你的小伙伴使用私募云App\n扫一扫该二维码加入%@", userInfo.organizationName];
    tishi.attributedText = [self attributedStringWithStr:text];
    tishi.textAlignment  = NSTextAlignmentCenter;
    [tishi sizeToFit];
    tishi.x = (scanWidth - tishi.width) * 0.5;
    tishi.y = CGRectGetMaxY(labele.frame) + 10;
    [self addSubview:tishi];
    self.tishi = tishi;

    // 分割线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = YTColor(208, 208, 208);
    line.frame           = CGRectMake(0, CGRectGetMaxY(tishi.frame) + 15, scanWidth, 1);
    [self addSubview:line];

    // 分享标题
    UILabel *title = [[UILabel alloc] init];
    title.text      = @"分享";
    title.font      = [UIFont systemFontOfSize:14];
    title.textColor = YTColor(51, 51, 51);
    [title sizeToFit];
    title.x = (scanWidth - title.width) * 0.5;
    title.y = CGRectGetMaxY(line.frame) + 15;
    [self addSubview:title];

    // 朋友圈分享按钮
    UIButton *weChatQuan = [UIButton buttonWithType:UIButtonTypeCustom];
    [weChatQuan setImage:[UIImage imageNamed:@"Share_ScanPengyouquan"]
                forState:UIControlStateNormal];
    [weChatQuan addTarget:self
                   action:@selector(weChatQuanClick)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weChatQuan];
    //  设置文字
    UILabel *weChatQuanTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 12)];
    weChatQuanTitle.font          = [UIFont systemFontOfSize:10];
    weChatQuanTitle.textAlignment = NSTextAlignmentCenter;
    weChatQuanTitle.textColor     = YTColor(51, 51, 51);
    weChatQuanTitle.text          = @"朋友圈";
    [self addSubview:weChatQuanTitle];
    [weChatQuanTitle sizeToFit];
    weChatQuan.frame       = CGRectMake((scanWidth * 0.5) - 25, CGRectGetMaxY(title.frame) + 15, 50, 50);
    weChatQuanTitle.center = CGPointMake(weChatQuan.center.x, weChatQuan.center.y + 35);

    // 微信分享按钮
    UIButton *weChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [weChat setImage:[UIImage imageNamed:@"Share_ScanWexin"]
            forState:UIControlStateNormal];
    [weChat addTarget:self
               action:@selector(weChatClick)
     forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:weChat];
    //  设置文字
    UILabel *weChatTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 12)];
    weChatTitle.font          = [UIFont systemFontOfSize:10];
    weChatTitle.textAlignment = NSTextAlignmentCenter;
    weChatTitle.textColor     = YTColor(51, 51, 51);
    weChatTitle.text          = @"微信";
    [self addSubview:weChatTitle];
    [weChatTitle sizeToFit];
    weChat.frame       = CGRectMake(weChatQuan.x - 85, CGRectGetMaxY(title.frame) + 15, 50, 50);
    weChatTitle.center = CGPointMake(weChat.center.x, weChat.center.y + 35);


    // 保存到相册
//    Savephoto
    UIButton *savePhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [savePhoto setImage:[UIImage imageNamed:@"Savephoto"]
               forState:UIControlStateNormal];
    [savePhoto addTarget:self
                  action:@selector(SavephotoClick)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:savePhoto];
    //  设置文字
    UILabel *svaeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 12)];
    svaeTitle.font          = [UIFont systemFontOfSize:10];
    svaeTitle.textAlignment = NSTextAlignmentCenter;
    svaeTitle.textColor     = YTColor(51, 51, 51);
    svaeTitle.text          = @"保存相册";
    [self addSubview:svaeTitle];
    [svaeTitle sizeToFit];
    savePhoto.frame  = CGRectMake(CGRectGetMaxX(weChatQuan.frame) + 35, CGRectGetMaxY(title.frame) + 15, 50, 50);
    svaeTitle.center = CGPointMake(savePhoto.center.x, savePhoto.center.y + 35);
}

/**
 *  分享到微信
 */
- (void)weChatClick
{
    // 截屏效果
    UIImageView *continer = [[UIImageView alloc] init];
    continer.image  = [UIImage imageNamed:@"ScanJiepin"];
    continer.size   = CGSizeMake(scanWidth + 10, 352);
    continer.alpha  = 0.0;
    continer.center = self.center;
    continer.y      = self.y - 5;
    [_window addSubview:continer];

    // 截屏区域
    CGRect clipFrame = continer.frame;
    clipFrame.origin.x   += 5;
    clipFrame.origin.y    = self.y;
    clipFrame.size.width  = scanWidth;
    clipFrame.size.height = 346;
    // 截图
    UIImage *screenImage = [_window screenshotWithRect:clipFrame];

    // 动画
    [UIView animateWithDuration:0.5
                     animations:^{
        continer.alpha = 1.0;
    }
                     completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self destroy];
            [self.shareManage
             wxShareWithFile:UIImagePNGRepresentation(screenImage)];
            continer.alpha = 0.0;
        });
    }];
}

/**
 *  分享到朋友圈
 */
- (void)weChatQuanClick
{
    // 截屏效果
    UIImageView *continer = [[UIImageView alloc] init];
    continer.image  = [UIImage imageNamed:@"ScanJiepin"];
    continer.size   = CGSizeMake(scanWidth + 10, 352);
    continer.alpha  = 0.0;
    continer.center = self.center;
    continer.y      = self.y - 5;
    [_window addSubview:continer];

    // 截屏区域
    CGRect clipFrame = continer.frame;
    clipFrame.origin.x   += 5;
    clipFrame.origin.y    = self.y;
    clipFrame.size.width  = scanWidth - 1;
    clipFrame.size.height = 346;
    // 截图
    UIImage *screenImage = [_window screenshotWithRect:clipFrame];

    // 动画
    [UIView animateWithDuration:0.5
                     animations:^{
        continer.alpha = 1.0;
    }
                     completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self destroy];
            [self.shareManage
             wxpyqShareWithFile:UIImagePNGRepresentation(screenImage)];
            continer.alpha = 0.0;
        });
    }];
}

/**
 *  保存到相册
 */
- (void)SavephotoClick
{
    // 截屏效果
    UIImageView *continer = [[UIImageView alloc] init];
    continer.image  = [UIImage imageNamed:@"ScanJiepin"];
    continer.size   = CGSizeMake(scanWidth + 10, 352);
    continer.alpha  = 0.0;
    continer.center = self.center;
    continer.y      = self.y - 5;
    [_window addSubview:continer];

    // 截屏区域
    CGRect clipFrame = continer.frame;
    clipFrame.origin.x   += 5;
    clipFrame.origin.y    = self.y;
    clipFrame.size.width  = scanWidth - 1;
    clipFrame.size.height = 346;
    // 截图
    UIImage *screenImage = [_window screenshotWithRect:clipFrame];

    // 动画
    [UIView animateWithDuration:0.5
                     animations:^{
        continer.alpha = 1.0;
    }
                     completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            continer.alpha = 0.0;
            UIImageWriteToSavedPhotosAlbum(screenImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    }];
}

// 指定回调方法

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo

{
    if (error != NULL)
    {
        [SVProgressHUD showErrorWithStatus:@"二维码保存失败"];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"二维码保存成功"];
    }
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

    //根据给定长度与style设置attStr式样]
    [attStr addAttribute:NSParagraphStyleAttributeName
                   value:style
                   range:NSMakeRange(0, str.length)];
    return attStr;
}

- (void)show
{
    // 退出键盘
    for (UIWindow *window in [UIApplication sharedApplication].windows)
    {
        if (window.windowLevel == 0)
        {
            [window endEditing:YES];
            break;
        }
    }
    [UIView animateWithDuration:0.5
                     animations:^{
        self.alpha = 1;
    }
                     completion:^(BOOL finished) {
    }];
}

- (void)destroy
{
    self.alpha = 0;
    [self.imageV removeFromSuperview];
    self.imageV = nil;
    [self.nickNameLable removeFromSuperview];
    self.nickNameLable = nil;
    [self.jigou removeFromSuperview];
    self.jigou = nil;
    [self.photo removeFromSuperview];
    self.photo = nil;
    [self.logo removeFromSuperview];
    self.logo = nil;
    [self.tishi removeFromSuperview];
    self.tishi = nil;
    [self.endDate removeFromSuperview];
    self.endDate     = nil;
    self.shareManage = nil;
    [self removeFromSuperview];
    _window.hidden = YES;
    _window        = nil;
}

- (ShareManage *)shareManage
{
    if (!_shareManage)
    {
        ShareManage *share = [ShareManage shareManage];
        [share shareConfig];
        share.share_title   = nil;
        share.share_image   = nil;
        share.share_url     = nil;
        share.share_content = nil;
        share.bankNumber    = nil;
        _shareManage        = share;
    }
    return _shareManage;
}

@end
