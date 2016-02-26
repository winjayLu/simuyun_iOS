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
    [self.bgView imageWithUrlStr:product.hotName phImage:[UIImage imageNamed:@"tuxiangzhanwei"]];
    
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
//        self.fbTitle.text = @"封闭期";
//        self.fbContent.text = _product.close_stage;
//        self.jzTitle.text = @"累计净值";
//        self.jzContent.text = _product.cumulative_net;
    } else
    {
        self.leijiJingzhiLable.text = [NSString stringWithFormat:@"预期收益：%@",_product.expected_yield];
        self.fenbiqiLable.text = [NSString stringWithFormat:@"期限：%@", _product.term];
//        
//        self.fbTitle.text = @"期限";
//        self.fbContent.text = _product.term;
//        self.jzTitle.text = @"预期收益";
//        self.jzContent.text = _product.expected_yield;
    }
    
    // 设置已经募集金额
    if (_product.raised_amt > 10000) {
        self.benqimujiLable.text = [NSString stringWithFormat:@"%.2f亿",_product.raised_amt / 10000 ];
//        self.danWeiLable.text = @"亿";
//        self.yimujiLable.text = [NSString stringWithFormat:@"%.2f",_product.raised_amt / 10000];
    } else {
        self.benqimujiLable.text = [NSString stringWithFormat:@"%.0f万",_product.raised_amt];
//        self.danWeiLable.text = @"万";
//        self.yimujiLable.text = [NSString stringWithFormat:@"%.0f",_product.raised_amt];
    }
    // 设置总募集金额
    if (_product.totalAmt > 10000) {
        self.totalAmtLable.text = [NSString stringWithFormat:@"项目总募集：%.2f亿",_product.totalAmt / 10000];
//        self.totalDanWeiLable.text = @"亿";
//        self.totalAmtLable.text = [NSString stringWithFormat:@"%.2f",_product.totalAmt / 10000];
    } else {
        self.totalAmtLable.text = [NSString stringWithFormat:@"项目总募集：%.0f万",_product.totalAmt];
//        self.totalDanWeiLable.text = @"万";
//        self.totalAmtLable.text = [NSString stringWithFormat:@"%.0f",_product.totalAmt];
    }
    
    
//    if (_product.state == 20)    // 产品状态
//    {
//        // 暂停募集
//        self.danWeiLable.text = @"暂停募集";
//        self.endTimeLabel.hidden = YES;
//        self.endtimeTitleLable.hidden = YES;
//        self.yimujiLable.hidden = YES;
//        self.bgImageView.image = [UIImage imageNamed:@"huimogu"];
//        self.proImageView.image = [UIImage imageNamed:@"proHuiseLable"];
//    } else {
//        self.proImageView.image = [UIImage imageNamed:@"proLanseLable"];
//        self.endTimeLabel.hidden = NO;
//        self.yimujiLable.hidden = NO;
//        self.endtimeTitleLable.hidden = NO;
//        self.bgImageView.image = [UIImage imageNamed:@"logobackground"];
//        
        // 设置截止打款时间
        if (_product.componentsDate.day > 0) {
            if (_product.componentsDate.hour > 17)
            {
                [self.jiejiTimeLable setTitle:[NSString stringWithFormat:@"截止打款%zd天", _product.componentsDate.day + 1] forState:UIControlStateNormal];
//                self.endTimeLabel.text = ;
            } else {
                [self.jiejiTimeLable setTitle:[NSString stringWithFormat:@"截止打款%zd天", _product.componentsDate.day] forState:UIControlStateNormal];
//                self.endTimeLabel.text = [NSString stringWithFormat:@"%zd天", ];
            }
        } else if (_product.componentsDate.hour > 0) {
            [self.jiejiTimeLable setTitle:[NSString stringWithFormat:@"截止打款%zd小时", _product.componentsDate.hour] forState:UIControlStateNormal];
//            self.endTimeLabel.text = [NSString stringWithFormat:@"%zd小时", _product.componentsDate.hour];
        } else if (_product.componentsDate.minute > 0) {
            [self.jiejiTimeLable setTitle:[NSString stringWithFormat:@"截止打款%zd分钟", _product.componentsDate.minute] forState:UIControlStateNormal];
//            self.endTimeLabel.text = [NSString stringWithFormat:@"%zd分钟", _product.componentsDate.minute];
        }
//        self.endTimeLabel.text = [NSString stringWithFormat:@"%zd分钟", 54];
//    }
    
//    // 旋转lable
//    self.endTimeLabel.transform = CGAffineTransformMakeRotation(M_PI_4);
//    // iphone 6 以下屏幕特殊适配
//    if (DeviceWidth < 375)
//    {
//        self.fenbiqiLeftConstraint.constant = 4.0;
//        self.yimujiLable.font = [UIFont systemFontOfSize:18];
//        self.yimujiBottomConstraint.constant = 2;
//    }
}

@end
