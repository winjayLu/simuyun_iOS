//
//  YTNormalWebController.h
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTProductModel.h"

@interface YTNormalWebController : UIViewController
/**
 *  网页的url地址
 */
@property (nonatomic, copy) NSString *url;


/**
 *  页面标题
 */
@property (nonatomic, copy) NSString *toTitle;

// 是否加时间戳
@property (nonatomic, assign) BOOL isDate;

// 是否显示进度条
@property (nonatomic, assign) BOOL isProgress;


+ (instancetype)webWithTitle:(NSString *)title url:(NSString *)url;
@end
