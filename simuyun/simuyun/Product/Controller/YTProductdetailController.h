//
//  YTProductdetailController.h
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTProductModel.h"

@interface YTProductdetailController : UIViewController
/**
 *  网页的url地址
 */
@property (nonatomic, copy) NSString *url;


@property (nonatomic, strong) YTProductModel *product;
@end
