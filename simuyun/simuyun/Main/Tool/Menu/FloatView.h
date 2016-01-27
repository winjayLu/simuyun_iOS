//
//  FloatView.h
//  FloatMenu
//
//  Created by Johnny on 14/9/6.
//  Copyright (c) 2014年 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatView : NSObject

//底部window
@property (nonatomic, strong) UIWindow *boardWindow;
+ (FloatView *)defaultFloatViewWithButton;

/**
 *  删除悬浮窗
 */
- (void)removeFloatView;
@end
