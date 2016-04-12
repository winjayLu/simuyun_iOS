//
//  UIWindow+Extension.h
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Extension)

/**
 *  选择根控制器
 */
- (void)chooseRootviewController;
/**
 *  部分区域截图
 */
- (UIImage *)screenshotWithRect:(CGRect)rect;

@end
