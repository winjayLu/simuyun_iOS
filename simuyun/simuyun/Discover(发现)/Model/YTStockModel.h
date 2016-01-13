//
//  YTStockModel.h
//  simuyun
//
//  Created by Luwinjay on 15/10/18.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTStockModel : NSObject

/**
 *  名称
 */
@property (nonatomic, copy) NSString *name;
/**
 *  当前指数
 */
@property (nonatomic, assign) double index;
/**
 *  涨跌率
 */
@property (nonatomic, assign) double rate;
/**
 *  成交量
 */
@property (nonatomic, assign) double volume;
/**
 *  成交额
 */
//@property (nonatomic, assign) double turnover;

/**
 *  当前涨跌
 */
@property (nonatomic, assign) double gain;


@end
