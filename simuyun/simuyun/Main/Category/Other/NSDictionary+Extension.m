//
//  NSDictionary+Extension.m
//  simuyun
//
//  Created by Luwinjay on 15/9/23.
//  Copyright © 2015年 winjay. All rights reserved.
//

#import "NSDictionary+Extension.h"

@implementation NSDictionary (Extension)
/**
 *  将普通字典转换成http请求字典
 *
 *  @param dict 传入的普通字典
 *
 *  @return 用于发送请求的字典
 */
+ (NSDictionary *)httpWithDictionary:(NSDictionary *)dict
{
    // 获取字典中所有的key
    NSArray *allKey = [dict allKeys];
    // 保存请求参数
    NSMutableString *param = [NSMutableString string];
    // 转化后的http字典
    NSMutableDictionary *httpDict = [NSMutableDictionary dictionary];
    for (NSString *key in allKey) {
        if (param.length == 0) {
            [param appendFormat:@"{\"%@\" : \"%@\"",key , dict[key]];
        } else {
            [param appendFormat:@",\"%@\" : \"%@\"",key , dict[key]];
        }
    }
    if (param)
    {
        [param appendString:@"}"];
        httpDict[@"param"] = param;
    }
    
    return httpDict;
}
@end
