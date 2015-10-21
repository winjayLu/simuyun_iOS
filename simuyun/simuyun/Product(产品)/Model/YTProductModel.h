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
 *  产品id
 */
@property (nonatomic, copy) NSString *pro_id;

/**
 *  icon标签
 */
@property (nonatomic, assign) int label;

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
 *  封闭期
 */
@property (nonatomic, copy) NSString *close_stage;




@end
