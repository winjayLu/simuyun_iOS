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
 *  32位MD5加密
 */
@property (nonatomic,copy,readonly) NSString *md5;





/**
 *  SHA1加密
 */
@property (nonatomic,copy,readonly) NSString *sha1;





@end
