//
//  YTHotProductCell.m
//  simuyun
//
//  Created by Luwinjay on 16/2/26.
//  Copyright © 2016年 YTWealth. All rights reserved.
//

#import "YTHotProductCell.h"
#import "UIImageView+SD.h"

// 左右间距
#define maginWidth 7

@interface YTHotProductCell()

// 产品名称
@property (weak, nonatomic) IBOutlet UILabel *proNameLable;

// 截止募集时间
@property (weak, nonatomic) IBOutlet UIButton *jiejiTimeLable;

// 热门标语
@property (weak, nonatomic) IBOutlet UILabel *hotNameLable;

// 累计净值
@property (weak, nonatomic) IBOutlet UILabel *leijiJingzhiLable;

// 起投
@property (weak, nonatomic) IBOutlet UILabel *qitouLable;

// 封闭期
@property (weak, nonatomic) IBOutlet UILabel *fenbiqiLable;

// 本期募集金额
@property (weak, nonatomic) IBOutlet UILabel *benqimujiLable;

// 项目总募集
@property (weak, nonatomic) IBOutlet UILabel *totalAmtLable;

// 背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@end


@implementation YTHotProductCell

/**
 *  修改Cell的frame
 *
 */
- (void)setFrame:(CGRect)frame
{
    CGRect newF = {{frame.origin.x + maginWidth, frame.origin.y}, {frame.size.width - maginWidth * 2, frame.size.height}};
    [super setFrame:newF];
}


+ (instancetype)hotProductCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTHotProductCell" owner:nil options:nil] lastObject];
}

/**
 *  设置数据
 *
 */
- (void)setProduct:(YTProductModel *)product
{
    
    _product = product;
    
    // 设置图片
    [self.bgView imageWithUrlStr:product.marketingImageUrl phImage:[UIImage imageNamed:@"tuxiangzhanwei"]];
    
    // 设置标题
    self.proNameLable.text = _product.pro_name;
    
    // 设置营销话术
    self.hotNameLable.text = _product.hotName;
    
    // 设置投资起点
    self.qitouLable.text = [NSString stringWithFormat:@"起投：%@", _product.buy_start];
    
    // 判断是固收还是浮收
    if (_product.type_code == 1) { // 浮收
        self.leijiJingzhiLable.text = [NSString stringWithFormat:@"累计净值：%@",_product.cumulative_net];
        self.fenbiqiLable.text = [NSString stringWithFormat:@"封闭期：%@", _product.close_stage];
    } else
    {
        self.leijiJingzhiLable.text = [NSString stringWithFormat:@"预期收益：%@",_product.expected_yield];
        self.fenbiqiLable.text = [NSString stringWithFormat:@"期限：%@", _product.term];
    }
    
    // 设置已经募集金额
    if (_product.raised_amt > 10000) {
        self.benqimujiLable.text = [NSString stringWithFormat:@"%.2f亿",_product.raised_amt / 10000 ];
    } else {
        self.benqimujiLable.text = [NSString stringWithFormat:@"%.0f万",_product.raised_amt];
    }
    // 设置总募集金额
    if (_product.totalAmt > 10000) {
        self.totalAmtLable.text = [NSString stringWithFormat:@"项目总募集：%.2f亿",_product.totalAmt / 10000];
    } else {
        self.totalAmtLable.text = [NSString stringWithFormat:@"项目总募集：%.0f万",_product.totalAmt];
    }
        // 设置截止打款时间
        if (_product.componentsDate.day > 0) {
            if (_product.componentsDate.hour > 17)
            {
                [self.jiejiTimeLable setTitle:[NSString stringWithFormat:@"截止打款%zd天", _product.componentsDate.day + 1] forState:UIControlStateNormal];
            } else {
                [self.jiejiTimeLable setTitle:[NSString stringWithFormat:@"截止打款%zd天", _product.componentsDate.day] forState:UIControlStateNormal];
            }
        } else if (_product.componentsDate.hour > 0) {
            [self.jiejiTimeLable setTitle:[NSString stringWithFormat:@"截止打款%zd小时", _product.componentsDate.hour] forState:UIControlStateNormal];
        } else if (_product.componentsDate.minute > 0) {
            [self.jiejiTimeLable setTitle:[NSString stringWithFormat:@"截止打款%zd分钟", _product.componentsDate.minute] forState:UIControlStateNormal];
        }
}

@end
