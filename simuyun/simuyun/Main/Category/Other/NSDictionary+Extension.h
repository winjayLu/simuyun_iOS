//
//  NSDictionary+Extension.h
//  simuyun
//
//  Created by Luwinjay on 15/9/23.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extension)
/**
 *  将普通字典转换成http请求字典
 *
 *  @param dict 传入的普通字典
 *
 *  @return 用于发送请求的字典
 */
+ (NSDictionary *)httpWithDictionary:(NSDictionary *)dict;
@end
