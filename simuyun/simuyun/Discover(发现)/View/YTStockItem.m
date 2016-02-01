//
//  YTStockItem.m
//  simuyun
//
//  Created by Luwinjay on 15/10/16.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTStockItem.h"

@interface YTStockItem()

/**
 *  名称
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

/**
 *  当前指数
 */
@property (weak, nonatomic) IBOutlet UILabel *indexLable;
/**
 *  当前涨跌
 */
@property (weak, nonatomic) IBOutlet UILabel *gainLable;
/**
 *  涨跌率
 */
@property (weak, nonatomic) IBOutlet UILabel *rateLable;
/**
 *  背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation YTStockItem

+ (instancetype)stockItem
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTStockItem" owner:nil options:nil] firstObject];
}

- (void)setStockModel:(YTStockModel *)stockModel
{
    _stockModel = stockModel;
    self.nameLable.text = stockModel.name;
    self.indexLable.text = [NSString stringWithFormat:@"%.2f",stockModel.index];
    self.gainLable.text = [NSString stringWithFormat:@"%.2f", stockModel.gain];
    self.rateLable.text = [NSString stringWithFormat:@"%.2f%%", stockModel.rate];
    if (stockModel.gain >= 0) {
        self.indexLable.textColor = YTColor(200,22,29);
        self.gainLable.textColor = YTColor(200,22,29);
        self.rateLable.textColor = YTColor(200,22,29);
        self.bgImageView.image = [UIImage imageNamed:@"shangsheng"];
    } else {
        self.indexLable.textColor = YTColor(0,119,72);
        self.gainLable.textColor = YTColor(0,119,72);
        self.rateLable.textColor = YTColor(0,119,72);
        self.bgImageView.image = [UIImage imageNamed:@"xiadie"];
    }
    
}

@end
