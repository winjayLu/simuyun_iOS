//
//  UIView+Extension.m
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 winjay. All rights reserved.
//
//  用来方便获取控件frame

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


/**
 *  屏幕宽度
 */
static CGFloat _deviceWidth;
+ (CGFloat)deviceWidth
{
    if (!_deviceWidth) {
        _deviceWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return _deviceWidth;
}

/**
 *  屏幕高度
 */
static CGFloat _deviceHight;
+ (CGFloat)deviceHight
{
    if (!_deviceHight) {
        _deviceHight = [UIScreen mainScreen].bounds.size.height;
    }
    return _deviceHight;
}

/**
 *  屏幕的Frame
 */
static CGRect _deviceBounds;
+ (CGRect)deviceBounds
{
    if (_deviceBounds.size.width == 0.0) {
        _deviceBounds = [UIScreen mainScreen].bounds;
    }
    
    return _deviceBounds;
}

@end
