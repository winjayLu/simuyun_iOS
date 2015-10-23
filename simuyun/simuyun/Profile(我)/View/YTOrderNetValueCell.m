//
//  YTOrderNetValueCell.m
//  simuyun
//
//  Created by Luwinjay on 15/10/23.
//  Copyright © 2015年 YTWealth. All rights reserved.
//

#import "YTOrderNetValueCell.h"

@interface YTOrderNetValueCell()

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


@end

@implementation YTOrderNetValueCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
