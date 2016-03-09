//
//  MrLoadingView.m
//  MrLoadingView
//
//  Created by ChenHao on 2/11/15.
//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import "HHAlertView.h"
#import "UIImage+Extend.h"
#import "NSDate+Extension.h"
#import "NSString+Extend.h"


#define alertWidth  285
#define alertHeight  305

NSInteger const titleFont = 20;

@interface HHAlertView() <UITextViewDelegate>

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UITextView *detailView;
@property (nonatomic, weak) UIButton *okButton;
@property (nonatomic, weak) UIButton *closeButton;
@property (nonatomic, weak) UIImageView *logoView;

@property (nonatomic, copy) selectButton secletBlock;

@end


@implementation HHAlertView

+ (instancetype)hiddenAlloc
{
    return [super alloc];
}

+ (instancetype)alloc
{
    return nil;
}

+ (instancetype)new
{
    return [self alloc];
}

+ (instancetype)shared
{
    
    static dispatch_once_t once = 0;
    static HHAlertView *alert;
    dispatch_once(&once, ^{
        alert = [[self hiddenAlloc] init];
    });
    return alert;
}

- (void)showAlertWithStyle:(HHAlertStyle)HHAlertStyle
                 imageName:(NSString *)imagename
                     Title:(NSString *)title
                    detail:(NSString *)detail
              cancelButton:(NSString *)cancel
                  Okbutton:(NSString *)ok
                     block:(selectButton)block
{
    [self showAlertWidtTitle:title detail:detail Okbutton:ok block:block];
}




static UIWindow *_window;

- (void)showAlertWidtTitle:(NSString *)title detail:(NSString *)detail Okbutton:(NSString *)ok block:(selectButton)block
{
    [self destroy];
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _window.backgroundColor = YTRGBA(0, 0, 0, 0.4);
    _window.alpha = 1;
    _window.windowLevel = 4000;
    _window.hidden = NO;
    [_window makeKeyAndVisible];
    
    // 弹框
    [self setFrame:CGRectMake((DeviceWidth - alertWidth) * 0.5, (DeviceHight- alertHeight) * 0.5 - 20, alertWidth, alertHeight)];
    self.alpha = 0;
    [self setBackgroundColor:YTColor(246, 246, 246)];
    [_window addSubview:self];
    
    // 关闭按钮
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"guanbianxia"] forState:UIControlStateHighlighted];
    [closeButton addTarget:self action:@selector(dismissWithCancel) forControlEvents:UIControlEventTouchUpInside];
    closeButton.size = CGSizeMake(44, 44);
    closeButton.center = self.center;
    closeButton.y = CGRectGetMaxY(self.frame) + 40;
    [_window addSubview:closeButton];
    self.closeButton = closeButton;
    
    // 初始化文本
    [self configtext:title detail:detail];
    // 初始化按钮
    [self configButton:ok];
    _secletBlock = block;
    [self show];
}



#pragma mark private method
- (void)configtext:(NSString *)title detail:(NSString *)detail
{
    if (_logoView == nil) {
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alertBanner"]];
        imageV.frame = CGRectMake(0, 0, alertWidth, 100);
        [self addSubview:imageV];
        self.logoView = imageV;
    }
    
    if (_titleLabel == nil) {
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_logoView.frame) + 15, alertWidth - 50, titleFont)];
        [titleLable setFont:[UIFont systemFontOfSize:titleFont]];
        [titleLable setTextAlignment:NSTextAlignmentCenter];
        [titleLable setTextColor:YTColor(51, 51, 51)];
        [self addSubview:titleLable];
        self.titleLabel = titleLable;
    }
    self.titleLabel.text = title;
    
    UIFont *font = [UIFont systemFontOfSize:14];
    if (_detailView == nil ) {
        UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_titleLabel.frame) + 15, alertWidth - 50, 70)];
        textV.textColor = YTColor(102, 102, 102);
        textV.backgroundColor = YTColor(246, 246, 246);
        textV.delegate = self;
        [textV setFont:font];
        [self addSubview:textV];
        self.detailView = textV;
    }
    self.detailView.text = detail;

    CGRect tmpRect = [detail boundingRectWithSize:CGSizeMake(alertWidth - 50, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    self.detailView.contentSize = CGSizeMake(alertWidth - 50, tmpRect.size.height + 10);
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}




- (void)configButton:(NSString *)ok
{
    if (_okButton == nil) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_detailView.frame) + 20, alertWidth - 50, 44)];
        [button setTitle:ok forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"alertOKbtn"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"alertOKbtnHL"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(dismissWithOk) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.okButton = button;
    }
    
}


- (void)dismissWithCancel
{
    if (_secletBlock!=nil) {
        _secletBlock(HHAlertButtonCancel);
    }
    [self destroy];
}

- (void)dismissWithOk
{
    if (_secletBlock!=nil) {
        _secletBlock(HHAlertButtonOk);
    }

    [self destroy];
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
    
    [_okButton removeFromSuperview];
    [_closeButton removeFromSuperview];
    [_titleLabel removeFromSuperview];
    [_detailView removeFromSuperview];
    _okButton = nil;
    _titleLabel = nil;
    _detailView = nil;
    _closeButton = nil;
    _secletBlock = nil;
    _window.hidden = YES;
    _window = nil;
}


@end
