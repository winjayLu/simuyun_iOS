//
//  YTViewPdfViewController.h
//  simuyun
//
//  Created by Luwinjay on 15/11/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTProductModel.h"

@interface YTViewPdfViewController : UIViewController
/**
 *  网页的url地址
 */
@property (nonatomic, copy) NSString *url;



/**
 *  分享标题
 */
@property (nonatomic, copy) NSString *shareTitle;


/**
 *  产品模型
 */
@property (nonatomic, strong) YTProductModel *product;
@end
