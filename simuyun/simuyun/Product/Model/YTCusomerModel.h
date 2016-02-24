//
//  YTCusomerModel.h
//  simuyun
//
//  Created by Luwinjay on 15/12/10.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTCusomerModel : NSObject


/**
 *  客户id
 */
@property (nonatomic, copy) NSString *cust_id;

/**
 *  客户名称
 */
@property (nonatomic, copy) NSString *cust_name;

/**
 *  证件类型
 */
@property (nonatomic, copy) NSString *credentialsname;

/**
 *  证件号码
 */
@property (nonatomic, copy) NSString *credentialsnumber;

// 银行名称
@property (nonatomic, copy) NSString *cust_bank;

// 银行支行
@property (nonatomic, copy) NSString *cust_bank_detail;

// 银行帐号
@property (nonatomic, copy) NSString *cust_bank_acct;


@end
