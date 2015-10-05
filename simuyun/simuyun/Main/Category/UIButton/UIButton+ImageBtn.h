//
//  UIButton+ImageBtn.h
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (ImageBtn)


/**
 *  快速生成一个含有图片的按钮:默认按钮大小和图片一样
 *
 *  @param imageName        普通状态图片名
 *  @param highlightedImage 高亮状态图片名
 *
 *  @return 按钮
 */
+(UIButton *)buttonWithImageName:(NSString *)imageName highlightedImage:(NSString *)highlightedImage;


@end
