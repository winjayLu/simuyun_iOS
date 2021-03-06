//
//  NSString+Extend.m
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.

#import "NSString+Extend.h"
#import "AGNumberForBank.h"

@implementation NSString (Extend)


/*
 *  时间戳对应的NSDate
 */
-(NSDate *)date{
    
    NSTimeInterval timeInterval=self.floatValue;
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

/**
 *  获取银行名称
 */

+(NSString *)getBankFromCardNumber:(NSString *)bank
{
    if ([bank length] < 6) {
        return @"";
    }
    const char *bankChar = [bank UTF8String];
    char *retChar = getNameOfBank(bankChar, 0);
    NSString *bankName = [NSString stringWithCString:retChar encoding:NSUTF8StringEncoding];
    
    // 去掉卡类型
    NSArray *bankArr = [bankName componentsSeparatedByString:@"."];
    if (bankArr && bankArr.count>0) {
        return bankArr[0];
    }
    return bankName;
}


/**
 *  将时间转换为NSDate
 */

- (NSDate *)stringWithDate:(NSString *)format
{
    //设置转换格式
    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    //NSString转NSDate
    return [formatter dateFromString:self];
}

/**
 *  生成唯一的字符串
 */
+ (NSString *)createCUID{
    NSString *  result;
    CFUUIDRef   uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result =[NSString stringWithFormat:@"%@",uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}


//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark 计算字符串大小
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize textSize = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return textSize;
}


@end
