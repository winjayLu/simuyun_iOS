//
//  YTAccount.m
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//
//  账号模型

#import "YTAccount.h"
#import "NSString+Password.h"

@implementation YTAccount

/**
 *  密码加密
 *
 */
- (void)setPassword:(NSString *)password
{
    _password = [NSString md5:password];
}

MJCodingImplementation
@end
