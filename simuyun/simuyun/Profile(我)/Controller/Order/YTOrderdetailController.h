//
//  YTOrderdetailController.h
//  simuyun
//
//  Created by Luwinjay on 15/10/29.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOrderCenterModel.h"


@interface YTOrderdetailController : UIViewController
/**
 *  网页的url地址
 */
@property (nonatomic, copy) NSString *url;


// 订单模型
@property (nonatomic, strong) YTOrderCenterModel *order;
@end
