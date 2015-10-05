//
//  MBProgressHUD+WJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 winjay. All rights reserved.
//

#import "MBProgressHUD.h"


@interface MBProgressHUD (WJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;


+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
//  显示录音指示器
+ (MBProgressHUD *)showAudio;
//  隐藏录音指示器
+ (void)hidAudio;
/**
 *  设置录音指示器的图片
 */
+ (void)setImageName:(NSString *)imageName;


@end
