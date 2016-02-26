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

@property (weak, nonatomic) IBOutlet UIImageView *proImageView;

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
 *  项目总募集
 */
@property (weak, nonatomic) IBOutlet UILabel *totalAmtLable;


/**
 *  单位Lable,默认为万
 */
@property (weak, nonatomic) IBOutlet UILabel *totalDanWeiLable;


/**
 *  截止打款时间
 */
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;


/**
 *  截止打款时间
 */
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLable;


/**
 *  背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

/**
 *  截止打款标题
 */
@property (weak, nonatomic) IBOutlet UILabel *endtimeTitleLable;

/**
 *  封闭期左侧约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fenbiqiLeftConstraint;

/**
 *  已募集金额底部约束
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *yimujiBottomConstraint;

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
        self.fbTitle.text = @"期限";
        self.fbContent.text = _product.term;
        self.jzTitle.text = @"预期收益";
        self.jzContent.text = _product.expected_yield;
    }
    
    // 设置已经募集金额
    if (_product.raised_amt > 10000) {
        self.danWeiLable.text = @"亿";
        self.yimujiLable.text = [NSString stringWithFormat:@"%.2f",_product.raised_amt / 10000];
    } else {
        self.danWeiLable.text = @"万";
        self.yimujiLable.text = [NSString stringWithFormat:@"%.0f",_product.raised_amt];
    }
    // 设置总募集金额
    if (_product.totalAmt > 10000) {
        self.totalDanWeiLable.text = @"亿";
        self.totalAmtLable.text = [NSString stringWithFormat:@"%.2f",_product.totalAmt / 10000];
    } else {
        self.totalDanWeiLable.text = @"万";
        self.totalAmtLable.text = [NSString stringWithFormat:@"%.0f",_product.totalAmt];
    }
    
    
    if (_product.state == 20)    // 产品状态
    {
        // 暂停募集
        self.endTimeLabel.hidden = YES;
        self.yimujiLable.textColor = YTColor(102, 102, 102);
        self.bgImageView.image = [UIImage imageNamed:@"huimogu"];
        self.proImageView.image = [UIImage imageNamed:@"proHuiseLable"];
    } else {
        self.proImageView.image = [UIImage imageNamed:@"proLanseLable"];
        self.endTimeLabel.hidden = NO;
        self.yimujiLable.textColor = YTColor(215, 58, 46);
        self.bgImageView.image = [UIImage imageNamed:@"logobackground"];
        
        // 设置截止打款时间
        if (_product.componentsDate.day > 0) {
            if (_product.componentsDate.hour > 17)
            {
                self.endTimeLabel.text = [NSString stringWithFormat:@"%zd天", _product.componentsDate.day + 1];
            } else {
                self.endTimeLabel.text = [NSString stringWithFormat:@"%zd天", _product.componentsDate.day];
            }
        } else if (_product.componentsDate.hour > 0) {
            self.endTimeLabel.text = [NSString stringWithFormat:@"%zd小时", _product.componentsDate.hour];
        } else if (_product.componentsDate.minute > 0) {
            self.endTimeLabel.text = [NSString stringWithFormat:@"%zd分钟", _product.componentsDate.minute];
        }
        // 旋转lable
        self.endTimeLabel.transform = CGAffineTransformMakeRotation(M_PI_4);
    }
    
    // iphone 6 以下屏幕特殊适配
    if (DeviceWidth < 375)
    {
        self.fenbiqiLeftConstraint.constant = 4.0;
        self.yimujiLable.font = [UIFont systemFontOfSize:18];
        self.yimujiBottomConstraint.constant = 2;
    }
}

@end
