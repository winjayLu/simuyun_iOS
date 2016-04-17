//
//  YTOrderCenterModel.h
//  simuyun
//
//  Created by Luwinjay on 15/10/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTOrderCenterModel : NSObject

/**
 *  订单编码
 */
@property (nonatomic, copy) NSString *order_code;

/**
 *  订单id
 */
@property (nonatomic, copy) NSString *order_id;


/**
 *  产品id
 */
@property (nonatomic, copy) NSString *product_id;



/**
 *  产品名称
 */
@property (nonatomic, copy) NSString *product_name;

/**
 *  订单状态
 */
@property (nonatomic, assign) int status;

/**
 *  认购时间
 */
@property (nonatomic, copy) NSString *create_time;

/**
 *  认购期限
 */
@property (nonatomic, copy) NSString *term;

/**
 *  截至时间
 */
@property (nonatomic, copy) NSString *end_date;


/**
 *  客户名称
 */
@property (nonatomic, copy) NSString *cust_name;

/**
 *  认购金额
 */
@property (nonatomic, assign) int order_amt;

/**
 *  认购净值
 */
@property (nonatomic, assign) double buy_net;

/**
 *  认购份额
 */
@property (nonatomic, copy) NSString *buy_shares;

/**
 *  是否可赎回
 */
@property (nonatomic, assign) int isRedeem;

/**
 *  可赎回订单状态
 */
@property (nonatomic, assign) int apply_status;


@end
