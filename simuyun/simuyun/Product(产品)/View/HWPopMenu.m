//
//  HWPopMenu.m
//  simuyun
//
//  Created by Luwinjay on 15/10/15.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "HWPopMenu.h"

@interface HWPopMenu()

@end

@implementation HWPopMenu

static UIImageView *_container;
static DismissBlock _dismiss;
static UIWindow *_window;
static UIButton *_cover;
static UIViewController *_contentVc;

+ (void)popFromRect:(CGRect)rect inView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(DismissBlock)dismiss
{
    _contentVc = contentVc;
    
    [self popFromRect:rect inView:view content:contentVc.view dismiss:dismiss];
}

+ (void)popFromView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(DismissBlock)dismiss
{
    _contentVc = contentVc;
    
    [self popFromView:view content:contentVc.view dismiss:dismiss];
}

+ (void)popFromRect:(CGRect)rect inView:(UIView *)view content:(UIView *)content dismiss:(DismissBlock)dismiss
{
    _dismiss = [dismiss copy];
    
    _window = [[UIWindow alloc] init];
    _window.frame = [UIScreen mainScreen].bounds;
    _window.backgroundColor = [UIColor clearColor];
    _window.windowLevel = UIWindowLevelAlert;
    _window.hidden = NO;
    
    // 遮盖
    UIButton *cover = [[UIButton alloc] init];
    cover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    [cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    cover.frame = [UIScreen mainScreen].bounds;
    [_window addSubview:cover];
    _cover = cover;
    
    // 容器
    UIImageView *container = [[UIImageView alloc] init];
    container.userInteractionEnabled = YES;
    container.image = [UIImage imageNamed:@"popover_background_right"];
    
    [_window addSubview:container];
    _container = container;
    
    // 添加内容到容器中
    content.x = 2;
    content.y = 18;
    [container addSubview:content];
    
    // 计算容器的尺寸
    container.width = CGRectGetMaxX(content.frame) - content.x;
    container.height = CGRectGetMaxY(content.frame) + content.x;
    container.centerX = CGRectGetMidX(rect);
    container.y = CGRectGetMaxY(rect);
    
    // 转换位置
    container.center = [view convertPoint:container.center toView:_window];
}

/**
 *  弹出一个菜单
 *
 *  @param view    菜单的箭头指向谁
 *  @param content 菜单里面的内容
 */
+ (void)popFromView:(UIView *)view content:(UIView *)content dismiss:(DismissBlock)dismiss
{
    [self popFromRect:view.bounds inView:view content:content dismiss:dismiss];
//    [self popFromRect:view.frame inView:view.superview content:content dismiss:dismiss];
}

/**
 *  点击遮盖
 */
+ (void)coverClick
{
    [_cover removeFromSuperview];
    _cover = nil;
    
    [_container removeFromSuperview];
    _container = nil;
    
    _contentVc = nil;
    
    // 调用dismiss
    if (_dismiss) {
        _dismiss(); // 调用nil的block,直接报内存错误
        _dismiss = nil;
    }
    
    _window.hidden = YES;
    _window = nil;
}
@end
