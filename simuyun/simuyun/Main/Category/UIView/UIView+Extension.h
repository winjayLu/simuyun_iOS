//
//  UIView+Extension.h
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 winjay. All rights reserved.
//
//  用来方便获取控件frame

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

/**
 *  屏幕宽度
 */
+ (CGFloat)deviceWidth;

/**
 *  屏幕高度
 */
+ (CGFloat)deviceHight;

/**
 *  屏幕Frame
 */
+ (CGRect)deviceBounds;
@end
