//
//  MBProgressHUD+WJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 winjay. All rights reserved.
//

#import "MBProgressHUD+WJ.h"
#import <UIKit/UIKit.h>

@implementation MBProgressHUD (WJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}
/**
 *  显示录音指示器
 *
 */
static UIImageView *_imageView;
static NSString *_imageName;
+ (MBProgressHUD *)showAudio
{
    UIWindow *systemWindow = [[UIApplication sharedApplication].windows lastObject];
    
    // 创建一个imageView 用来显示录音图片
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(0, 0, 75, 111);
    [_imageView setImage:[UIImage imageNamed:@"record_animate_01"]];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:systemWindow animated:NO];
    hud.customView = _imageView;
    // 设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
//
    return nil;
}
+ (void)hidAudio
{
    [self hideHUDForView:nil];
    _imageView = nil;
    _imageName = nil;
}
/**
 *  更改图片
 */
+ (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [_imageView setImage:[UIImage imageNamed:_imageName]];
}



+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
