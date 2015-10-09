//
//  UIView+Extension.h
//
//  Created by apple on 14-10-7.
//  Copyright (c) 2014年 winjay. All rights reserved.
//
//  用来方便获取控件frame

#import <UIKit/UIKit.h>


#define CustomViewTranslate(ViewClass,view) (ViewClass *)view;


typedef enum{
    
    //上
    UIViewBorderDirectTop=0,
    
    //左
    UIViewBorderDirectLeft,
    
    //下
    UIViewBorderDirectBottom,
    
    //右
    UIViewBorderDirectRight,
    
    
}UIViewBorderDirect;

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic,assign) CGFloat radius;

///**
// *  屏幕宽度
// */
//+ (CGFloat)deviceWidth;
//
///**
// *  屏幕高度
// */
//+ (CGFloat)deviceHight;
//
///**
// *  屏幕Frame
// */
//+ (CGRect)deviceBounds;


/**
 *  添加边框：注给scrollView添加会出错
 *
 *  @param direct 方向
 *  @param color  颜色
 *  @param width  线宽
 */
-(void)addSingleBorder:(UIViewBorderDirect)direct color:(UIColor *)color width:(CGFloat)width;


/**
 *  自动从xib创建视图
 */
+(instancetype)viewFromXIB;


/**
 *  添加一组子view：
 */
-(void)addSubviewsWithArray:(NSArray *)subViews;


/**
 *  添加边框:四边
 */
-(void)setBorder:(UIColor *)color width:(CGFloat)width;



/**
 *  调试
 */
-(void)debug:(UIColor *)color width:(CGFloat)width;



/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+(void)removeViews:(NSArray *)views;


@end
