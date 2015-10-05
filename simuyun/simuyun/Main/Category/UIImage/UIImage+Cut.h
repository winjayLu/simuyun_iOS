//
//  UIImage+Cut.h
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (Cut)


/**
 *  从给定UIView中截图：UIView转UIImage
 */
+(UIImage *)cutFromView:(UIView *)view;


/**
 *  直接截屏
 */
+(UIImage *)cutScreen;



/**
 *  从给定UIImage和指定Frame截图：
 */
-(UIImage *)cutWithFrame:(CGRect)frame;




@end
