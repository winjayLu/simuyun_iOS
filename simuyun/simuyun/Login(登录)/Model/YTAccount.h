//
//  YTAccount.h
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  账号模型

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface YTAccount : NSObject <NSCoding>
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *userId;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;
/**
 *  token
 */
@property (nonatomic, copy) NSString *token;


@end
