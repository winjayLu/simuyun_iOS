//
//  YTRedeemModel.h
//  simuyun
//
//  Created by Luwinjay on 16/4/13.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTRedeemModel : NSObject

/**
 *  订单id
 */
@property (nonatomic, copy) NSString *orderId;

/**
 *  结束时间
 */
@property (nonatomic, copy) NSString *redeemEndTime;

/**
 *  客户姓名
 */
@property (nonatomic, copy) NSString *custName;

/**
 *  银行卡号
 */
@property (nonatomic, copy) NSString *redeemBankAccount;

/**
 *  开户行
 */
@property (nonatomic, copy) NSString *bankName;

/**
 *  1浮收
 *  2固收
 */
@property (nonatomic, assign) int productType;

/**
 *  赎回金额
 */
@property (nonatomic, copy) NSString *redeemAmt;

/**
 *  赎回说明
 */
@property (nonatomic, copy) NSString *redeemDescription;

/**
 *  相关文件
 */
@property (nonatomic, strong) NSArray *fileUrl;



@end
