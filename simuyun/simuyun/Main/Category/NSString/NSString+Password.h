//
//  NSString+Password.h
//  simuyun
//
//  Created by Luwinjay on 15/10/6.
//  Copyright (c) 2015年 YTWealth. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Password)




/**
 *  8位MD5加密
 */
+(NSString *)md5:(NSString *)password;

+ (NSString*)decrypt:(NSString*)encryptText;

+ (NSString*)encrypt:(NSString*)plainText;

/**
 *  SHA1加密
 */
@property (nonatomic,copy,readonly) NSString *sha1;


@end
