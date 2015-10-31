//
//  HWPopMenu.h
//  simuyun
//
//  Created by Luwinjay on 15/10/15.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DismissBlock)();

@interface HWPopMenu : NSObject
/**
 *  弹出一个菜单
 *
 *  @param view    菜单的箭头指向谁
 *  @param content 菜单里面的内容
 *  @param dismiss 菜单销毁的时候想做的事情
 */
+ (void)popFromView:(UIView *)view content:(UIView *)content dismiss:(DismissBlock)dismiss;

/**
 *  弹出一个菜单
 *
 *  @param view    参照系
 *  @param rect    菜单的箭头指向的矩形框
 *  @param content 菜单里面的内容
 *  @param dismiss 菜单销毁的时候想做的事情
 */
+ (void)popFromRect:(CGRect)rect inView:(UIView *)view content:(UIView *)content dismiss:(DismissBlock)dismiss;


/**
 *  弹出一个菜单
 *
 *  @param view    菜单的箭头指向谁
 *  @param contentVc 菜单里面的内容
 *  @param dismiss 菜单销毁的时候想做的事情
 */
+ (void)popFromView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(DismissBlock)dismiss;

/**
 *  弹出一个菜单
 *
 *  @param view    参照系
 *  @param rect    菜单的箭头指向的矩形框
 *  @param contentVc 菜单里面的内容
 *  @param dismiss 菜单销毁的时候想做的事情
 */
+ (void)popFromRect:(CGRect)rect inView:(UIView *)view contentVc:(UIViewController *)contentVc dismiss:(DismissBlock)dismiss;
@end
