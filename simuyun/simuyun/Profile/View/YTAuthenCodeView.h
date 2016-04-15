//
//  YTAuthenCodeView.h
//  simuyun
//
//  Created by Luwinjay on 16/4/15.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

// 认证口令

@interface YTAuthenCodeView : UIView


+ (instancetype)shared;

/**
 *  展示的内容
 */
@property (copy, nonatomic) NSString *content;

- (void)showScanWithVc:(UIViewController *)vc;


@end
