//
//  YTOrderCenterController.h
//  simuyun
//
//  Created by Luwinjay on 15/10/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOrderCenterController : UIViewController


/**
 *  已选则分类status
 */
@property (nonatomic, copy) NSString *status;

/**
 *  是否显示完成订单
 */
@property (nonatomic, assign) BOOL isYiQueRen;

/**
 *  是否显示可赎回订单
 */
@property (nonatomic, assign) BOOL isRedeem;

/**
 *  是否从订单跳转过来
 */
@property (nonatomic, assign) BOOL isOrder;

/**
 *  从我的客户过来
 *  客户id
 */
@property (nonatomic, copy) NSString *custId;


@end
