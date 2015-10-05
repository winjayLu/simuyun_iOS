//
//  YTMenuViewController.h
//  simuyun
//
//  Created by Luwinjay on 15/9/28.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YTMenuViewControllerDelegate <NSObject>
@optional
- (void)didSelectItem:(NSString *)title;

@end

@interface YTMenuViewController : UIViewController
@property (weak, nonatomic) id<YTMenuViewControllerDelegate> delegate;
@end
