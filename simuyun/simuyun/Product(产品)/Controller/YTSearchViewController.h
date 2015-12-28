//
//  YTSearchViewController.h
//  simuyun
//
//  Created by Luwinjay on 15/12/21.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol searchViewControllerDelegate <NSObject>

- (void)searchViewDismiss;

@end


@interface YTSearchViewController : UIViewController

/**
 *  热门搜索
 */
@property (nonatomic, strong) NSArray *products;

/**
 *  代理
 */
@property (nonatomic, weak) id searchDelegate;

@end
