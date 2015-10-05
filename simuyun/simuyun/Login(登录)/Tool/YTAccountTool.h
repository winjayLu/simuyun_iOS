//
//  YTAccountTool.h
//  YTWealth
//
//  Created by WJ-China on 15/9/6.
//  Copyright (c) 2015年 winjay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTAccount;

@interface YTAccountTool : NSObject

/**
 *  存储帐号信息
 */
+ (void)save:(YTAccount *)account;

/**
 *  获得上次存储的帐号
 */
+ (YTAccount *)account;

@end
