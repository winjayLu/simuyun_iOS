//
//  YTLiquidationCell.m
//  simuyun
//
//  Created by Luwinjay on 15/12/9.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTLiquidationCell.h"
#import "UIImageView+SD.h"


// 左右间距
#define maginWidth 7

@interface YTLiquidationCell()


/**
 *  产品标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

/**
 *  投资起点
 */
@property (weak, nonatomic) IBOutlet UILabel *buyStartLable;


/**
 *  封闭期的标题
 *  or 投资期限
 */
@property (weak, nonatomic) IBOutlet UILabel *fbTitle;

/**
 *  封闭期内容
 */
@property (weak, nonatomic) IBOutlet UILabel *fbContent;

/**
 *  累计净值的标题
 *  or 预期收益
 */
@property (weak, nonatomic) IBOutlet UILabel *jzTitle;
/**
 *  累计净值内容
 */
@property (weak, nonatomic) IBOutlet UILabel *jzContent;

/**
 *  以募集金额
 */
@property (weak, nonatomic) IBOutlet UILabel *yimujiLable;


/**
 *  单位Lable,默认为万
 */
@property (weak, nonatomic) IBOutlet UILabel *danWeiLable;

/**
 *  右上角Icon
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation YTLiquidationCell


/**
 *  修改Cell的frame
 *
 */
- (void)setFrame:(CGRect)frame
{
    CGRect newF = {{frame.origin.x + maginWidth, frame.origin.y}, {frame.size.width - maginWidth * 2, frame.size.height}};
    [super setFrame:newF];
}


+ (instancetype)productCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTLiquidationCell" owner:nil options:nil] lastObject];
}

/**
 *  设置数据
 *
 */
- (void)setProduct:(YTProductModel *)product
{
    _product = product;
    
    // 设置标题
    self.titleLable.text = _product.pro_name;
    
    // 设置投资起点
    self.buyStartLable.text = _product.buy_start;
    
    // 判断是固收还是浮收
    if (_product.type_code == 1) { // 浮收
        self.fbTitle.text = @"封闭期";
        self.fbContent.text = _product.close_stage;
        self.jzTitle.text = @"累计净值";
        self.jzContent.text = _product.cumulative_net;
    } else
    {
        self.fbTitle.text = @"投资期限";
        self.fbContent.text = _product.term;
        self.jzTitle.text = @"预期收益";
        self.jzContent.text = _product.expected_yield;
    }
    
    // 设置已经募集金额
    if (_product.totalAmt > 10000) {
        self.danWeiLable.text = @"亿";
        self.yimujiLable.text = [NSString stringWithFormat:@"%.2f",_product.totalAmt / 10000];
    } else {
        self.danWeiLable.text = @"万";
        self.yimujiLable.text = [NSString stringWithFormat:@"%.0f",_product.totalAmt];
    }
    if (_product.state == 50) {
        self.iconImageView.image = [UIImage imageNamed:@"mujijieshu"];
    } else {
        self.iconImageView.image = [UIImage imageNamed:@"liquidation"];
    }
}



@end
