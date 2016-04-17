//
//  YTOrderCenterCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTOrderCenterCell.h"

// 左右间距
#define maginWidth 7

@interface YTOrderCenterCell()

/**
 *  标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLble;

/**
 *  订单状态图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

/**
 *  认购时间
 */
@property (weak, nonatomic) IBOutlet UILabel *renGouDateLable;

/**
 *  投资期限
 */
@property (weak, nonatomic) IBOutlet UILabel *qiXianDateLable;


/**
 *  单位万
 */
@property (weak, nonatomic) IBOutlet UILabel *unitLable;

/**
 *  客户名称
 */
@property (weak, nonatomic) IBOutlet UILabel *keHuLable;

/**
 *  投资金额
 */
@property (weak, nonatomic) IBOutlet UILabel *buyMoneyLable;

/**
 *  认购净值
 */
@property (weak, nonatomic) IBOutlet UILabel *jinZhiLable;

/**
 *  认购份额
 */
@property (weak, nonatomic) IBOutlet UILabel *fenELable;


@end


@implementation YTOrderCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 *  修改Cell的frame
 *
 */
- (void)setFrame:(CGRect)frame
{
    CGRect newF = {{frame.origin.x + maginWidth, frame.origin.y}, {DeviceWidth - maginWidth * 2, frame.size.height}};
    [super setFrame:newF];
}

+ (instancetype)orderCenterCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTOrderCenterCell" owner:nil options:nil] lastObject];
}

/**
 *  设置数据
 */
- (void)setOrder:(YTOrderCenterModel *)order
{
    _order = order;
    
    // 产品名称
    self.titleLble.text = order.product_name;
    
    // 订单状态
    if (order.isRedeem == 1) {
        self.iconImage.image = [UIImage imageNamed:@"redeemIcon"];
        switch (order.apply_status) {
            case 0:
            case 4:
                self.iconImage.image = [UIImage imageNamed:@"redeemDaishuhui"];
                break;
            case 1:
            case 2:
                self.iconImage.image = [UIImage imageNamed:@"redeemBanlizhong"];
                break;
            case 3:
                self.iconImage.image = [UIImage imageNamed:@"redeemYibohui"];
                break;
        }
    } else {
        switch (order.status) {
            case 50:
                self.iconImage.image = [UIImage imageNamed:@"orderstatus20"];
                break;
            case 90:
                self.iconImage.image = [UIImage imageNamed:@"orderstatus60"];
                break;
            default:
                self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"orderstatus%d",order.status]];
                break;
        }
    }
    
    // 认购时间
    self.renGouDateLable.text = [NSString stringWithFormat:@"认购时间：%@", order.create_time];
    
    // 认购期限
    if (order.term)
    {
    
        self.qiXianDateLable.text = [NSString stringWithFormat:@"投资期限：%@个月",order.term];
    } else {
        self.qiXianDateLable.text = @"投资期限";
    }
    
    // 到期时间
    if (order.end_date) {
        self.qiXianDateLable.text = [NSString stringWithFormat:@"%@（%@到期）",self.qiXianDateLable.text, order.end_date];
    }
    
    // 客户名称
    self.keHuLable.text = order.cust_name;
    
    // 投资金额
    self.buyMoneyLable.text = [NSString stringWithFormat:@"%d",order.order_amt];
    
    // 单位
    double newAmt = (double)order.order_amt / 10000.f;
    if (newAmt > 1) {
        self.buyMoneyLable.text = [NSString stringWithFormat:@"%.2f",newAmt];
        self.unitLable.text = @"亿";
    } else {
        self.unitLable.text = @"万";
    }
    
    // 认购净值 & 认购份额
    if (order.buy_net != 0 && order.buy_shares.length != 0) {
        self.jinZhiLable.text = [NSString stringWithFormat:@"认购净值：%.4f",order.buy_net];
        self.fenELable.text = [NSString stringWithFormat:@"认购份额：%@份",order.buy_shares];
        self.jinZhiLable.hidden = NO;
        self.fenELable.hidden = NO;
    } else {
        self.jinZhiLable.hidden = YES;
        self.fenELable.hidden = YES;
    }
    
}

@end
