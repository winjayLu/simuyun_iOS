//
//  NSString+Password.m
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//

#import "NSString+Password.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Password)


/**
 *  8位MD5加密
 */
+ (NSString *)md5:(NSString *)password
{
    NSString *ret = @"";
    ret = [self creatMd5:password];
    if ([ret length] >= 24) {
        ret = [ret substringWithRange:NSRangeFromString(@"{8,16}")];
    }
    return ret?ret:@"";
}


+(NSString *)creatMd5:(NSString *) inPutText
{
    const char *cStr = [inPutText UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}


/**
 *  SHA1加密
 */
-(NSString *)sha1{
    
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result copy];
}






@end
