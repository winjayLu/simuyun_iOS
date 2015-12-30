//
//  MrLoadingView.m
//  MrLoadingView
//
//  Created by ChenHao on 2/11/15.
//  Copyright (c) 2015 xxTeam. All rights reserved.
//

#import "HHAlertView.h"
#import "UIImage+Extend.h"


#define OKBUTTON_BACKGROUND_COLOR [UIColor colorWithRed:210/255.0 green:35/255.0 blue:21/255.0 alpha:1]
#define CANCELBUTTON_BACKGROUND_COLOR [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]

#define txtColor [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1]


#define HHAlertview_SIZE_WIDTH  (DeviceWidth - 100)
#define HHAlertview_SIZE_HEIGHT  250
NSInteger const Simble_SIZE = 30;
NSInteger const Simble_TOP = 0;

#define Button_SIZE_WIDTH  (HHAlertview_SIZE_WIDTH * 0.5)
NSInteger const Buutton_SIZE_HEIGHT      = 44;



NSInteger const HHAlertview_SIZE_TITLE_FONT = 20;
NSInteger const HHAlertview_SIZE_DETAIL_FONT = 14;

@interface HHAlertView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *OkButton;

@property (nonatomic, strong) UIImageView *logoView;

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


- (void)uiStyle
{
    [self setFrame:CGRectMake((DeviceWidth - HHAlertview_SIZE_WIDTH)/2, (DeviceHight- HHAlertview_SIZE_HEIGHT)/2, HHAlertview_SIZE_WIDTH, HHAlertview_SIZE_HEIGHT)];
    self.alpha = 0;
    [self setBackgroundColor:[UIColor whiteColor]];
}




static UIWindow *_window;
- (void)showAlertWithStyle:(HHAlertStyle)HHAlertStyle imageName:(NSString *)imagename Title:(NSString *)title detail:(NSString *)detail cancelButton:(NSString *)cancel Okbutton:(NSString *)ok block:(selectButton)block
{
 
    [self uiStyle];
    _secletBlock = block;
    
    [self drawTick:imagename];
    
    [self configtext:title detail:detail];
    
    [self jpushConfigButton:cancel Okbutton:ok];
    
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _window.backgroundColor = YTRGBA(0, 0, 0, 0.1);
    _window.alpha = 1;
    _window.windowLevel = UIWindowLevelStatusBar ;
    _window.hidden = NO;
    [_window makeKeyAndVisible];
    
    
    [_window addSubview:self];
    [self show];
    
}


- (void)hide
{
    [self destroy];
}


#pragma mark private method
- (void)configtext:(NSString *)title detail:(NSString *)detail
{
    if (_titleLabel==nil && title.length > 0) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_logoView.frame) + 10, [self getSelfSize].width, HHAlertview_SIZE_TITLE_FONT+5)];
    }
    
    _titleLabel.text = title;
    [_titleLabel setFont:[UIFont systemFontOfSize:HHAlertview_SIZE_TITLE_FONT]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:txtColor];
    [self addSubview:_titleLabel];
    
    if (_detailLabel == nil) {
        _detailLabel  = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 10, [self getSelfSize].width - 15, HHAlertview_SIZE_TITLE_FONT)];
        [_detailLabel setNumberOfLines:0];
    }
    if (detail != nil && detail.length > 0) {
        
        NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:detail];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:10];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [detail length])];
        [_detailLabel setAttributedText:attributedString1];
        [_detailLabel sizeToFit];
        _detailLabel.textColor = [UIColor grayColor];
        [_detailLabel setNumberOfLines:0];
        [_detailLabel setFont:[UIFont systemFontOfSize:HHAlertview_SIZE_DETAIL_FONT]];
        [_detailLabel setTextAlignment:NSTextAlignmentLeft];
        
        [_detailLabel sizeToFit];
        [_detailLabel setFrame:CGRectMake(15, CGRectGetMaxY(_titleLabel.frame) + 10, [self getSelfSize].width - 30, _detailLabel.frame.size.height)];
        [_detailLabel setTextColor:txtColor];
        [self addSubview:_detailLabel];
    }
    
    
}


- (void)jpushConfigButton:(NSString *)cancel Okbutton:(NSString *)ok
{
    
    if(cancel != nil)
    {
        CGFloat okBtnWidth = HHAlertview_SIZE_WIDTH * 0.67;
        CGFloat cancelBtnWidth = HHAlertview_SIZE_WIDTH * 0.33;
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_detailLabel.frame) + 15, cancelBtnWidth, Buutton_SIZE_HEIGHT)];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"pushBlack"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"pushBlackanxia"] forState:UIControlStateHighlighted];
        [_cancelButton setTitle:cancel forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismissWithCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        _OkButton = [[UIButton alloc] initWithFrame:CGRectMake(_cancelButton.frame.size.width, CGRectGetMaxY(_detailLabel.frame) + 15, okBtnWidth, Buutton_SIZE_HEIGHT)];
        [_OkButton setTitle:ok forState:UIControlStateNormal];
        [_OkButton setBackgroundImage:[UIImage imageNamed:@"pushok"] forState:UIControlStateNormal];
        [_OkButton setBackgroundImage:[UIImage imageNamed:@"pushokanxia"] forState:UIControlStateHighlighted];
        [_OkButton addTarget:self action:@selector(dismissWithOk) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_OkButton];
        
        CGFloat oldx = self.frame.origin.x;
        CGFloat oldw = self.frame.size.width;
        CGFloat viewH = CGRectGetMaxY(_cancelButton.frame);
        CGFloat viewY = (DeviceHight - viewH) * 0.5;
        self.frame = CGRectMake(oldx, viewY, oldw, viewH);
    } else {
        _OkButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_detailLabel.frame) + 15, Button_SIZE_WIDTH * 2, Buutton_SIZE_HEIGHT)];
        [_OkButton setTitle:ok forState:UIControlStateNormal];
        [_OkButton setBackgroundImage:[UIImage imageWithColor:OKBUTTON_BACKGROUND_COLOR] forState:UIControlStateNormal];
        [_OkButton setBackgroundImage:[UIImage imageWithColor:YTColor(171, 22, 28)] forState:UIControlStateHighlighted];
        [_OkButton addTarget:self action:@selector(dismissWithOk) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_OkButton];
        
        CGFloat oldx = self.frame.origin.x;
        CGFloat oldw = self.frame.size.width;
        CGFloat viewH = CGRectGetMaxY(_OkButton.frame);
        CGFloat viewY = (DeviceHight - viewH) * 0.5;
        self.frame = CGRectMake(oldx, viewY, oldw, viewH);
    }
}


- (void)dismissWithCancel
{
    if (_secletBlock!=nil) {
        _secletBlock(HHAlertButtonCancel);
    }
    [self hide];
}

- (void)dismissWithOk
{
    if (_secletBlock!=nil) {
        _secletBlock(HHAlertButtonOk);
    }

    [self hide];
}


- (void)destroy
{
    
    self.alpha=0;
    self.layer.cornerRadius = 5;
    self.layer.shadowOffset = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 0.3f;
    self.layer.shadowRadius = 20.0f;
    
    [_OkButton removeFromSuperview];
    [_cancelButton removeFromSuperview];
    _OkButton=nil;
    _cancelButton = nil;
    _secletBlock=nil;
    [self removeFromSuperview];
    _window.hidden = YES;
    _window = nil;
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


#pragma helper mehtod

- (CGSize)getSelfSize
{
    return self.frame.size;
}


#pragma draw method



- (void)drawTick:(NSString *)imagename
{
    [_logoView removeFromSuperview];
    
    UIImage *image = [UIImage imageNamed:imagename];
    
    
    _logoView = [[UIImageView alloc] initWithImage:image];
     _logoView.frame = (CGRect){{([self getSelfSize].width)/2 - (image.size.width * 0.5), - image
     .size.height * 0.5}, {image.size.width, image.size.height}};

    
    [self addSubview:_logoView];
}



@end
