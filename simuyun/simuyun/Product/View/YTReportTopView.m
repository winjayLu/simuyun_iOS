//
//  YTReportTopView.m
//  simuyun
//
//  Created by Luwinjay on 15/11/24.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTReportTopView.h"


@interface YTReportTopView()

/**
 *  产品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *productNameLable;
/**
 *  订单编号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLable;
/**
 *  客户名称
 */
@property (weak, nonatomic) IBOutlet UILabel *customerNameLable;
/**
 *  认购金额
 */
@property (weak, nonatomic) IBOutlet UILabel *buyMoneyLable;


@end

@implementation YTReportTopView


+ (instancetype)reportTopView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"YTReportTopView" owner:nil options:nil] firstObject];
}

/**
 *  设置数据
 *
 */
- (void)setProuctModel:(YTProductModel *)prouctModel
{
    _prouctModel = prouctModel;
    self.productNameLable.text = prouctModel.pro_name;
    
    self.orderCodeLable.text = [NSString stringWithFormat:@"订单编号：%@",prouctModel.order_code];
    self.customerNameLable.text = [NSString stringWithFormat:@"客户：%@", prouctModel.customerName];
    self.buyMoneyLable.text = [NSString stringWithFormat:@"认购金额：%d万", prouctModel.buyMoney];
}

@end
