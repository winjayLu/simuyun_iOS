////
////  YTTabBar.m
////  YTWealth
////
////  Created by WJ-China on 15/9/6.
////  Copyright (c) 2015年 winjay. All rights reserved.
////
//
//#import "YTTabBar.h"
//#import "UIView+Extension.h"
//#import "YTProfileViewController.h"
//#import "MBProgressHUD+WJ.h"
//
//
//#define YTButtonDuration  1.0
//
//@class YTLogoButton;
//
//@interface YTTabBar()
//
///**
// *  中间的按钮
// */
//@property (nonatomic, weak) YTLogoButton *logoButton;
//
//@end
//
///**
// *  自定义中间的按钮
// */
//@interface YTLogoButton : UIButton
//@end
//
//@implementation YTTabBar
//
//
///**
// *  通过代码创建控件
// */
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame]) {
//        [self setup];
//    }
//    return self;
//}
//
//
//
//
///**
// * 初始化
// */
//- (void)setup
//{
//    // 增加一个logo按钮
//    YTLogoButton *logoButton = [[YTLogoButton alloc] init];
//    [logoButton setBackgroundImage:[UIImage imageNamed:@"11"] forState:UIControlStateNormal];
//    [logoButton setBackgroundImage:[UIImage imageNamed:@"11"] forState:UIControlStateHighlighted];
//    [logoButton addTarget:self action:@selector(logoClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:logoButton];
//    self.logoButton = logoButton;
//    
//    // 设置tabbar的边框
//    self.layer.borderWidth = 0.50;
//    self.layer.borderColor = [UIColor whiteColor].CGColor;
//}
//
//- (void)logoClick:(YTLogoButton *)logoButton
//{
//    [YTCenter postNotificationName:@"" object:@""];
//    YTLog(@"sss");
//}
//
//
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    /** 设置所有UITabBarButton的位置和尺寸 */
//    // UITabBarButton的尺寸
//    CGFloat buttonW = self.width / 5;
//    CGFloat buttonH = self.height;
//    
//    // 按钮索引
//    int buttonIndex = 0;
//    
//    // 设置所有UITabBarButton的frame
//    CGRect buttonF;
// 
//    for (UIView *child in self.subviews) {
//        // 找到UITabBarButton
//        if ([child isKindOfClass:[UIControl class]] && ![child isKindOfClass:[UIButton class]]) {
//            CGFloat buttonX = buttonW * buttonIndex;
//            child.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
//            buttonF = child.frame;
//            // 增加索引
//            buttonIndex++;
//        }
//        if ([child isKindOfClass:[YTProfileViewController class]]) {
//            
//            [child setValue:@NO forKey:@"enabled"];
//            child.userInteractionEnabled = NO;
//        }
//    }
//    
//    /** 设置logo按钮的位置和尺寸 */
////    self.logoButton.size = self.logoButton.currentBackgroundImage.size;
//    self.logoButton.size = CGSizeMake(100, 100);
//    self.logoButton.center = CGPointMake(self.width * 0.5, self.height * 0.5);
//}
//
//@end
////
////@implementation YTLogoButton
////
////- (instancetype)initWithFrame:(CGRect)frame
////{
////    self = [super initWithFrame:frame];
////    if (self) {
////        // 给按钮添加长按事件
////        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong)];
////        longPress.minimumPressDuration = YTButtonDuration; //定义按的时间
////        [self addGestureRecognizer:longPress];
////    }
////    return self;
////}
////
/////**
//// * logo按钮长按
//// */
////- (void)btnLong
////{
////    YTLog(@"长按");
////#warning 显示录音指示器，开始录音
////    [MBProgressHUD showSuccess:@"开始录音"];
////    
////}
////- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
////{
////    YTLog(@"开始点击");
////}
////
////
////- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
////{
////    YTLog(@"手指松开");
////}
////
////- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
////{
//////    YTLog(@"手指松开");
////}
////
////@end
//
