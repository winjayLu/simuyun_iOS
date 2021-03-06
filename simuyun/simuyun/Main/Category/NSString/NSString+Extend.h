//
//  NSString+Extend.h
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extend)


/**
 *  将时间转换为NSDate
 */

- (NSDate *)stringWithDate:(NSString *)format;

/*
 *  时间戳对应的NSDate
 */
@property (nonatomic,strong,readonly) NSDate *date;


/**
 *  获取银行名称
 */
+ (NSString *)getBankFromCardNumber:(NSString *)bank;

/**
 *  生成唯一的字符串
 */
+ (NSString *)createCUID;



//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard;


#pragma mark 计算字符串大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
@end
