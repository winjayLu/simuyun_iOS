//
//  YTProductCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/15.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTProductCell.h"
#import "UIImageView+SD.h"
#import "NSDate+Extension.h"
#import "NSString+Extend.h"
#import "MZTimerLabel.h"

// 左右间距
#define maginWidth 7



@interface YTProductCell()

/**
 *  爆款icon
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
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
 *  title左边的约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftConstraint;
/**
 *  icon的宽度约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthConstraint;

/**
 *  截止打款时间
 */
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

/**
 *  时间单位
 */
@property (weak, nonatomic) IBOutlet UILabel *timeUnitLable;


/**
 *  背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

/**
 *  截止打款标题
 */
@property (weak, nonatomic) IBOutlet UILabel *endtimeTitleLable;


@end


@implementation YTProductCell


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
    return [[[NSBundle mainBundle] loadNibNamed:@"YTProductCell" owner:nil options:nil] lastObject];
}

/**
 *  设置数据
 *
 */
- (void)setProduct:(YTProductModel *)product
{
    _product = product;
    
    // 设置icon图片
    if (_product.series != 0) {
        self.iconWidthConstraint.constant = 25;
        self.titleLeftConstraint.constant = 8;
        self.iconImage.hidden = NO;
         [self.iconImage imageWithUrlStr:product.icon_url phImage:nil];
        // 调整icon的宽度
        if (_product.series > 6) {
            self.iconWidthConstraint.constant = 33;
        }
    } else
    {
        self.iconWidthConstraint.constant = 0;
        self.iconImage.hidden = YES;
        self.titleLeftConstraint.constant = -0.5;
    }

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
    if (_product.raised_amt > 10000) {
        _product.raised_amt = _product.raised_amt / 10000;
        self.danWeiLable.text = @"亿";
        self.yimujiLable.text = [NSString stringWithFormat:@"%.2f",_product.raised_amt];
    } else {
        self.danWeiLable.text = @"万";
        self.yimujiLable.text = [NSString stringWithFormat:@"%.0f",_product.raised_amt];
    }
    
    if (_product.state == 20)    // 产品状态
    {
        // 暂停募集
        self.timeUnitLable.text = @"暂停募集";
        self.endTimeLabel.hidden = YES;
        self.endtimeTitleLable.hidden = YES;
        self.bgImageView.image = [UIImage imageNamed:@"huimogu"];
    } else {
        self.endTimeLabel.hidden = NO;
        self.endtimeTitleLable.hidden = NO;
        self.bgImageView.image = [UIImage imageNamed:@"logobackground"];
        
        // 设置截止打款时间
        if (_product.componentsDate.day > 0) {
            self.endTimeLabel.text = [NSString stringWithFormat:@"%zd", _product.componentsDate.day];
            self.timeUnitLable.text = @"天";
        } else if (_product.componentsDate.hour > 0) {
            self.endTimeLabel.text = [NSString stringWithFormat:@"%zd", _product.componentsDate.hour];
            self.timeUnitLable.text = @"小时";
        } else if (_product.componentsDate.minute > 0) {
            self.endTimeLabel.text = [NSString stringWithFormat:@"%zd", _product.componentsDate.minute];
            self.timeUnitLable.text = @"分钟";
        }
    }
    
}

@end
