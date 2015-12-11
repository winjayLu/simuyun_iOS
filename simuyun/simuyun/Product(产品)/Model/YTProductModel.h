//
//  YTProductModel.h
//  simuyun
//
//  Created by Luwinjay on 15/10/15.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTProductModel : NSObject

/**
 *  产品状态
 *  10 正常
 *  20 停止
 *  30 清算
 */
@property (nonatomic, assign) int state;

/**
 *  产品id
 */
@property (nonatomic, copy) NSString *pro_id;

/**
 *  icon标签
 */
@property (nonatomic, assign) int series;

/**
 *  icon图片地址
 */
@property (nonatomic, copy) NSString *icon_url;

/**
 *  产品名称
 */
@property (nonatomic, copy) NSString *pro_name;


/**
 *  星星等级
 */
@property (nonatomic, assign) int level;


/**
 *  投资起点
 */
@property (nonatomic, copy) NSString *buy_start;

/**
 *  已募集金额
 */
@property (nonatomic, assign) double raised_amt;

/**
 *  分享子标题
 */
@property (nonatomic, copy) NSString *share_summary;

/**
 *  剩余额度
 *
 */
@property (nonatomic, assign) int remaining_amt;

/**
 *  产品类型
 *  1浮收
 *  2固收
 */
@property (nonatomic, assign) int type_code;

/**
 *  预期收益
 */
@property (nonatomic, copy) NSString *expected_yield;

/**
 *  累计净值
 */
@property (nonatomic, copy) NSString *cumulative_net;

/**
 *  投资期限
 */
@property (nonatomic, copy) NSString *term;

/**
 *  是否可以购买
 *  0不可以，1可以
 */
@property (nonatomic, assign) int canBuy;


/**
 *  封闭期
 */
@property (nonatomic, copy) NSString *close_stage;

// 开户名
@property (nonatomic, copy) NSString *raise_account_name;
// 募集账号
@property (nonatomic, copy) NSString *raise_account;
// 募集银行
@property (nonatomic, copy) NSString *raise_bank;

// 截至认购时间
@property (nonatomic, copy) NSString *pub_end_time;

/**
 *  距离现在的时间
 */
@property (nonatomic, strong) NSDateComponents *componentsDate;

#pragma mark - 订单字段
/**
 *  客户名称
 */
@property (nonatomic, copy) NSString *customerName;
/**
 *  认购金额
 */
@property (nonatomic, assign) int buyMoney;
/**
 *  订单id
 */
@property (nonatomic, copy) NSString *order_id;
/**
 *  订单编号
 */
@property (nonatomic, copy) NSString *order_code;

/**
 *  最晚报备时间
 */
@property (nonatomic, copy) NSString *report_deadline;




@end
