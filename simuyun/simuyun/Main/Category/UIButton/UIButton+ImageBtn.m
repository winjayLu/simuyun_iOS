//
//  UIButton+ImageBtn.h
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//

#import "UIButton+ImageBtn.h"

@implementation UIButton (ImageBtn)


/**
 *  快速生成一个含有图片的按钮:默认按钮大小和图片一样
 *
 *  @param imageName        普通状态图片名
 *  @param highlightedImage 高亮状态图片名
 *
 *  @return 按钮
 */
+(UIButton *)buttonWithImageName:(NSString *)imageName highlightedImage:(NSString *)highlightedImage{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *imageForNarmal=[UIImage imageNamed:imageName];
    UIImage *imagehighlighted = [UIImage imageNamed:highlightedImage];
    
    //设置不同状态下的图片
    [btn setImage:imageForNarmal forState:UIControlStateNormal];
    [btn setImage:imagehighlighted forState:UIControlStateHighlighted];
    
    btn.frame=(CGRect){CGPointZero,imageForNarmal.size};
    
    return btn;
}



- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self centerImageAndTitle:DEFAULT_SPACING];
}



@end
