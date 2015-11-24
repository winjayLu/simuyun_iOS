//
//  YTBlackAlertView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/25.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTBlackAlertView.h"

#define maginLeft 52
#define titleFont 20
#define detailFont 15
#define alertWidth DeviceWidth - 2 * maginLeft

#define signMaginLeft 55

@interface YTBlackAlertView()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) UIImageView *bg;
@property (nonatomic, copy) titleClcik titleblock;


@end

@implementation YTBlackAlertView

+ (instancetype)hiddenAlloc
{
    return [super alloc];
}


+ (instancetype)shared
{
    static dispatch_once_t once = 0;
    static YTBlackAlertView *alert;
    dispatch_once(&once, ^{
        alert = [[self hiddenAlloc] init];
    });
    return alert;
}

/**
 *  初始化
 */
- (void)style
{
    [self setFrame:CGRectMake(maginLeft, 200 , alertWidth, 200)];
    self.alpha = 0;
    [self setBackgroundColor:[UIColor clearColor]];
}

/**
 *  普通文字
 */
static UIWindow *_window;
- (void)showAlertWithTitle:(NSString *)title detail:(NSString *)detail
{
    // 初始化配置
    [self style];
    // 设置标题文字
    [self configtext:title detail:detail];
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _window.backgroundColor = YTRGBA(0, 0, 0, 0.1);
    _window.alpha = 1;
    _window.windowLevel = UIWindowLevelStatusBar ;
    _window.hidden = NO;
    [_window makeKeyAndVisible];
    // 设置背景图片
    UIImageView *bg = [[UIImageView alloc] initWithFrame:_window.bounds];
    [bg setImage:[UIImage imageNamed:@"tanxhaungbeijing"]];
    [_window addSubview:bg];
    [_window addSubview:self];
    self.bg = bg;
    [self show];
}


/**
 *  设置文字
 *
 */
- (void)configtext:(NSString *)title detail:(NSString *)detail
{

    // 标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.width, titleFont)];
    titleLable.text = title;
    [titleLable setFont:[UIFont systemFontOfSize:titleFont]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [titleLable setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLable];
    self.titleLabel = titleLable;
    
    // 内容
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLable.frame) + 25, self.width, detailFont)];
    [detailLabel setNumberOfLines:0];
//    detailLabel.text = detail;
    detailLabel.textColor = [UIColor whiteColor];
    [detailLabel setFont:[UIFont systemFontOfSize:detailFont]];
    
    
    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:detail];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:8];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [detail length])];
    [detailLabel setAttributedText:attributedString1];
    [detailLabel setTextAlignment:NSTextAlignmentCenter];

    
    
    [detailLabel sizeToFit];
    detailLabel.width = self.width;
    [self addSubview:detailLabel];
    self.detailLabel = detailLabel;
    
    // 按钮
    CGFloat btnMaginTop = 45;
    CGFloat btnW = 40;
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"guanbianxia"] forState:UIControlStateHighlighted];
    button.frame = CGRectMake((self.width - btnW) * 0.5,  CGRectGetMaxY(detailLabel.frame) + btnMaginTop, btnW, btnW);
    [button addTarget:self action:@selector(destroy) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    // 调整自身Frame
    CGFloat maxY = CGRectGetMaxY(button.frame);
    self.frame = CGRectMake(maginLeft, (DeviceHight - maxY) * 0.5, alertWidth, maxY);
}

- (void)show
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=1;
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowRadius = 20.0f;
    } completion:^(BOOL finished) {
        
    }];
    
}


- (void)destroy
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=0;
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowRadius = 20.0f;
    } completion:^(BOOL finished) {
        [_titleLabel removeFromSuperview];
        [_detailLabel removeFromSuperview];
        [_bg removeFromSuperview];
        _titleLabel=nil;
        _detailLabel = nil;
        _bg=nil;
        [self removeFromSuperview];
        _window.hidden = YES;
        _window = nil;
    }];
}

/**
 *  签到
 *
 */
- (void)showAlertSignWithTitle:(NSString *)title date:(NSString *)date yunDou:(NSString *)yunDou block:(titleClcik)block
{
    _titleblock = block;
    // 初始化配置
    [self style];
    // 设置标题文字
    [self configSignWithTitle:title date:date yunDou:yunDou];
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _window.backgroundColor = YTRGBA(0, 0, 0, 0.1);
    _window.alpha = 1;
    _window.windowLevel = UIWindowLevelStatusBar ;
    _window.hidden = NO;
    [_window makeKeyAndVisible];
    // 设置背景图片
    UIImageView *bg = [[UIImageView alloc] initWithFrame:_window.bounds];
    [bg setImage:[UIImage imageNamed:@"tanxhaungbeijing"]];
    [_window addSubview:bg];
    [_window addSubview:self];
    self.bg = bg;
    [self show];
}

/**
 *  初始化
 */
- (void)signStyle
{
    [self setFrame:CGRectMake(signMaginLeft, 200 , DeviceWidth - 2 * signMaginLeft, 200)];
    self.alpha = 0;
    [self setBackgroundColor:[UIColor clearColor]];
}
/**
 *  设置签到内容
 */
- (void)configSignWithTitle:(NSString *)title date:(NSString *)date yunDou:(NSString *)yunDou
{
    // 财经早知道
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, 180)];
    button.adjustsImageWhenHighlighted = NO;
    [button setBackgroundImage:[UIImage imageNamed:@"cjzzd"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(titleClcik) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    // 标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, button.height - 30,self.width - 20, 15)];
    titleLable.text = title;
    [titleLable setFont:[UIFont systemFontOfSize:15]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    [titleLable setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLable];
    
    // 签到日期
    UILabel *dateLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 20, self.width, 15)];
    dateLable.text = [NSString stringWithFormat:@"%@签到", date];
    dateLable.textColor = [UIColor whiteColor];
    [dateLable setFont:[UIFont systemFontOfSize:detailFont]];
    [dateLable setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:dateLable];
    
    // 云豆数量
    UILabel *yunDouLable = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dateLable.frame) + 10, self.width, 18)];
    yunDouLable.text = [NSString stringWithFormat:@"获得了%@个云豆", yunDou];
    yunDouLable.textColor = [UIColor whiteColor];
    [yunDouLable setFont:[UIFont systemFontOfSize:detailFont]];
    [yunDouLable setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:yunDouLable];
    
    CGFloat btnMaginTop = 25;
    CGFloat btnW = 40;
    UIButton *cancle = [[UIButton alloc] init];
    [cancle setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [cancle setBackgroundImage:[UIImage imageNamed:@"guanbianxia"] forState:UIControlStateHighlighted];
    cancle.frame = CGRectMake((self.width - btnW) * 0.5,  CGRectGetMaxY(yunDouLable.frame) + btnMaginTop, btnW, btnW);
    [cancle addTarget:self action:@selector(SignDestroy) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancle];
    
    // 调整自身Frame
    CGFloat maxY = CGRectGetMaxY(cancle.frame);
    self.frame = CGRectMake(signMaginLeft, (DeviceHight - maxY) * 0.5, DeviceWidth - 2 * signMaginLeft, maxY);
    
}

- (void)titleClcik
{
    if (_titleblock!=nil) {
        _titleblock();
    }
    [self SignDestroy];
}
- (void)SignDestroy
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=0;
        self.layer.cornerRadius = 5;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.3f;
        self.layer.shadowRadius = 20.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
        _window.hidden = YES;
        _window = nil;
    }];
}





@end
