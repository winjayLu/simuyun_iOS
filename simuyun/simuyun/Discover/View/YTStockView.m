//
//  YTStockView.m
//  simuyun
//
//  Created by Luwinjay on 15/10/16.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTStockView.h"
#import "YTStockItem.h"


#define topMagin 6.0f
#define leftMagin 7.5f


@implementation YTStockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YTColor(246, 246, 246);
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

/**
 *  设置数据
 *
 */
- (void)setStocks:(NSArray *)stocks
{
    _stocks = stocks;
    CGFloat itemW = 84;
    CGFloat itemH = 77;
    
    CGFloat maxW = 0.0;
    for (int i = 0; i < _stocks.count; i ++) {
        YTStockItem *item = [YTStockItem stockItem];
        item.stockModel = _stocks[i];
        item.backgroundColor = [UIColor whiteColor];
        item.layer.cornerRadius = 5;
        item.layer.masksToBounds = YES;
        maxW = i * (itemW + leftMagin);
        item.frame = CGRectMake(maxW, topMagin, itemW, itemH);

        [self addSubview:item];
    }
    self.contentSize = CGSizeMake(maxW + itemW , self.height);
}

@end
