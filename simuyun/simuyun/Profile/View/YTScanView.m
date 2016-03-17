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


#define scanWidth  285
#define scanHeight  350

@interface YTScanView()

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
    [self setFrame:CGRectMake((DeviceWidth - scanWidth) * 0.5, (DeviceHight- scanHeight) * 0.5 - 20, scanWidth, scanHeight)];
    self.alpha = 0;
    [self setBackgroundColor:[UIColor whiteColor]];
    [_window addSubview:self];
    
    // 过期日期
    [self setupDate];
    [self show];
}

- (void)setup
{
    YTUserInfo *userInfo = [YTUserInfoTool userInfo];
    // 头像
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 45, 45)];
    imageV.layer.masksToBounds = YES;
    imageV.layer.cornerRadius = 22.5;
    imageV.clipsToBounds = YES;
    [imageV imageWithUrlStr:userInfo.headImgUrl phImage:[UIImage imageNamed:@"avatar_default_big"]];
    [self addSubview:imageV];
    self.imageV = imageV;
    
    // 昵称
    CGFloat nickLableX = CGRectGetMaxX(imageV.frame) + 10;
    UILabel *nickNameLable = [[UILabel alloc] init];
    nickNameLable.width = self.width - nickLableX - 20;
    nickNameLable.font = [UIFont systemFontOfSize:18];
    nickNameLable.textColor = YTColor(51, 51, 51);
    nickNameLable.text = userInfo.realName;
    [nickNameLable sizeToFit];
    nickNameLable.x = nickLableX;
    nickNameLable.y = 20;
    [self addSubview:nickNameLable];
    self.nickNameLable = nickNameLable;
    
    // 机构
    UILabel *jigou = [[UILabel alloc] init];
    jigou.width = nickNameLable.width;
    jigou.font = [UIFont systemFontOfSize:14];
    jigou.textColor = YTColor(102, 102, 102);
    jigou.text = userInfo.organizationName;
    [jigou sizeToFit];
    jigou.x = nickLableX;
    jigou.y = CGRectGetMaxY(nickNameLable.frame) + 8;
    [self addSubview:jigou];
    self.jigou = jigou;
    
    // 二维码
    UIImageView *photo = [[UIImageView alloc] init];
    CGFloat photoWH = 187;
    photo.frame = CGRectMake((scanWidth - photoWH) * 0.5, CGRectGetMaxY(imageV.frame) + 20, photoWH, photoWH);
    [self addSubview:photo];
    self.photo = photo;
    
    // 截止日期
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60*7 sinceDate:[NSDate date]];
    NSString *dateStr = [nextDate stringWithFormater:@"yyyy-MM-dd"];
    
    NSString *appendStr = [NSString stringWithFormat:@"{\"party_id\":\"%@\",\"party_name\":\"%@\",\"uid\":\"%@\",\"deadline\":\"%@\",\"nickName\":\"%@\"}", userInfo.organizationId, userInfo.organizationName, [YTAccountTool account].userId, dateStr, [YTUserInfoTool userInfo].realName];

    NSString *content = [NSString stringWithFormat:@"http://www.simuyun.com/?%@", [NSString encrypt:appendStr]];
    // 设置图片
    photo.image = [LBXScanWrapper createQRWithString:content size:photo.size];
    
    // logo图片
    UIImageView *logo = [[UIImageView alloc] init];
    logo.image = [UIImage imageNamed:@"scanlogo"];
    logo.size = CGSizeMake(38, 38);
    logo.center = photo.center;
    [self addSubview:logo];
    self.logo = logo;
    
    // 提示语
    UILabel *tishi = [[UILabel alloc] init];
    tishi.width = photoWH;
    tishi.textColor = YTColor(102, 102, 102);
    tishi.font = [UIFont systemFontOfSize:14];
    tishi.numberOfLines = 0;
    tishi.text = [NSString stringWithFormat:@"让你的小伙伴使用私募云App扫一扫该二维码加入%@", userInfo.organizationName];
    [tishi sizeToFit];
    tishi.x = (scanWidth - photoWH) * 0.5;
    tishi.y = CGRectGetMaxY(photo.frame) + 20;
    [self addSubview:tishi];
    self.tishi = tishi;

    
}

- (void)setupDate
{
    UILabel *labele = [[UILabel alloc] init];
    labele.textColor = [UIColor whiteColor];
    labele.font = [UIFont systemFontOfSize:11];
    
    // 当前日期加7天
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//    [inputFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *inputDate = [NSDate date];
    NSDate *nextDate = [NSDate dateWithTimeInterval:24*60*60*7 sinceDate:inputDate];

    labele.text = [NSString stringWithFormat:@"该二维码7天内（%@前）有效", [nextDate stringWithFormater:@"MM月dd日"]];
    [labele sizeToFit];
    labele.x = (DeviceWidth - labele.width) * 0.5;
    labele.y = CGRectGetMaxY(self.frame) + 20;
    [_window addSubview:labele];
    self.endDate = labele;
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
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowRadius = 20.0f;
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
    
    [self removeFromSuperview];
    [self.endDate removeFromSuperview];
    _window.hidden = YES;
    _window = nil;
}
@end
