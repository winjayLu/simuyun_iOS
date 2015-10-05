//
//  YTProductTool.m
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2014年 winjay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTProduct;

@interface YTProductTool : NSObject
/**
 *  返回第page页的产品数据:page从1开始
 */
+ (NSArray *)collectProducts:(int)page;

+ (int)collectDealsCount;
@end
