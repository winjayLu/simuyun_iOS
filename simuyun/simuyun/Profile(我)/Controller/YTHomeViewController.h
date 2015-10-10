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
- (void)leftBtnClicked;

@end

@interface YTHomeViewController : UIViewController
@property (weak, nonatomic) id<YTHomeViewControllerDelegate> delegate;
@end
