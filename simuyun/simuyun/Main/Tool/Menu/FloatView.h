//
//  FloatView.h
//  FloatMenu
//
//  Created by Johnny on 14/9/6.
//  Copyright (c) 2014年 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FloatView : NSObject
//{
//    UIWindow        *_boardWindow;
//}
//底部window
@property (nonatomic, strong) UIWindow *boardWindow;
+ (FloatView *)defaultFloatViewWithButton;

- (void)removeFloatView;
@end
