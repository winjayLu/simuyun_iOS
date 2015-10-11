//
//  YTHomeViewController.h
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTHomeViewControllerDelegate <NSObject>
@optional
// 导航栏按钮点击事件
- (void)leftBtnClicked;
// 左侧菜单点击事件
- (void)leftMenuClicked;
@end

@interface YTHomeViewController : UIViewController
@property (weak, nonatomic) id<YTHomeViewControllerDelegate> delegate;
@end
