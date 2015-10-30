//
//  YTNormalWebController.h
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTNormalWebController : UIViewController
/**
 *  网页的url地址
 */
@property (nonatomic, copy) NSString *url;


/**
 *  页面标题
 */
@property (nonatomic, copy) NSString *toTitle;

+ (instancetype)webWithTitle:(NSString *)title url:(NSString *)url;
@end
