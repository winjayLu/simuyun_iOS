//
//  YTStockItem.m
//  simuyun
//
//  Created by Luwinjay on 15/10/16.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTStockItem.h"

@implementation YTStockItem

+ (instancetype)stockItem
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTStockItem" owner:nil options:nil] firstObject];
}

@end
